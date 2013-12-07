timeTracker.factory "$redmine", ($http, $rootScope, Base64) ->

  _redmines = {}

  return (auth, remove) ->
    if remove and _redmines[auth.url]?
      delete _redmines[auth.url]
      return
    if not _redmines[auth.url]
      _redmines[auth.url] = new Redmine(auth, $http, Base64, $rootScope)
    return _redmines[auth.url]


class Redmine

  CONTENT_TYPE: "application/json"
  AJAX_TIME_OUT: 30 * 1000
  SHOW: { DEFAULT: 0, NOT: 1, SHOW: 2 }
  NULLFUNC: () ->

  _equals = (y) ->
    return @url is y.url and @id is y.id

  constructor: (@auth, @$http, @Base64, @observer) ->
    @url = auth.url

  _projects: []

  _timeEntryData:
    "time_entry":
      "issue_id": 0
      "hours": 0
      "activity_id": 8
      "comments": ""

  ###
   convert json to xml.
  ###
  @JSONtoXML: (obj, depth) ->
    result = ""
    indent = ""
    depth = depth || 0

    i = depth
    while --i > 0 then indent += "  "
    for key, val of obj
      name = key
      if key.match(/^\d+$/) then name = "item"
      if typeof(val) is "object"
        result += indent + "<" + name + ">\n"
        depth++
        result += @JSONtoXML(val, depth)
        depth--
        result += indent + "</" + name + ">\n"
      else
        val = '' + val
        val = val.replace(/&amp;/g, "&").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&apos;")
        result += indent + "<" + name + ">" + val + "</" + name + ">\n"

    return result



  ###
   set basic configs for $http.
  ###
  setBasicConfig: (config, auth) ->
    config.headers = "Content-Type": @CONTENT_TYPE
    config.timeout = @AJAX_TIME_OUT
    if auth.apiKey? and auth.apiKey.length > 0
      config.headers["X-Redmine-API-Key"] = auth.apiKey
    else
      @$http.defaults.headers.common['Authorization'] = 'Basic ' + @Base64.encode(auth.id + ':' + auth.pass)
    return config


  ###
   load issues following selected project
  ###
  getIssues: (success, error, params) ->
    params.limit = 100
    config =
      method: "GET"
      url: @auth.url + "/issues.json"
      params: params
    config = @setBasicConfig config, @auth
    @$http(config)
      .success( (data, status, headers, config) =>
        if data?.issues?
          data.issues = for issue in data.issues
            issue.show = @SHOW.DEFAULT
            issue.url = @auth.url
            issue.equals = _equals
            issue
        success?(data, status, headers, config))
      .error(error or @NULLFUNC)


  ###
   Load tickets associated to user ID.
  ###
  getIssuesOnUser: (success, error) ->
    params =
      assigned_to_id: @auth.userId
    @getIssues(success, error, params)


  ###
   Load tickets on project.
  ###
  getIssuesOnProject: (projectId, success, error) ->
    params =
      project_id: projectId
    @getIssues(success, error, params)


  ###
   get any ticket using id.
  ###
  getIssuesById: (issueId, success, error) ->
    config =
      method: "GET"
      url: @auth.url + "/issues/#{issueId}.json"
    config = @setBasicConfig config, @auth
    @$http(config)
      .success( (data, status, headers, config) =>
        if data?.issue?
          data.issue.show = @SHOW.DEFAULT
          data.issue.url = @auth.url
        success?(data, status, headers, config))
      .error(error or @NULLFUNC)


  ###
   submit time entry to redmine server.
  ###
  submitTime: (config, success, error) ->
    @_timeEntryData.time_entry.issue_id    = config.issueId
    @_timeEntryData.time_entry.hours       = config.hours
    @_timeEntryData.time_entry.comments    = config.comment
    @_timeEntryData.time_entry.activity_id = config.activityId
    config =
      method: "POST"
      url: @auth.url + "/issues/#{@_timeEntryData.time_entry.issue_id}/time_entries.json"
      data: Redmine.JSONtoXML @_timeEntryData
    config = @setBasicConfig config, @auth
    config.headers = "Content-Type": "application/xml"
    @$http(config)
      .success(success or @NULLFUNC)
      .error(error or @NULLFUNC)


  ###
   return chached projects.
  ###
  getProjects: () ->
    return @_projects


  ###
   Load projects on url
  ###
  loadProjects: (success, error) ->
    config =
      method: "GET"
      url: @auth.url + "/projects.json"
    config = @setBasicConfig config, @auth
    @$http(config)
      .success( (data, status, headers, config) =>
        if data?.projects?
          data.projects = for prj in data.projects
            prj.text = prj.name
            prj.account = @auth
            prj
          @_projects = data.projects
          @observer.$broadcast 'projectsAdded', data.projects
        success?(data, status, headers, config))
      .error(error or @NULLFUNC)


  ###
   Load user on url associated to auth.
  ###
  _getUser: (success, error) ->
    config =
      method: "GET"
      url: @auth.url + "/users/current.json?include=memberships"
    config = @setBasicConfig config, @auth
    @$http(config)
      .success( (data, status, headers, config) =>
        @auth.userId = data.user.id
        success(data, status, headers, config))
      .error(error or @NULLFUNC)


  ###
   find user recursive.
  ###
  _findUser: (success, error) ->
    @auth.url = @auth.url.substring(0, @auth.url.lastIndexOf('/'))
    if not @auth.url.match(/^https?:\/\/.+/) then error(); return
    @_getUser(success, () => @_findUser(success, error))


  ###
   find user from url.
  ###
  findUser: (success, error) ->
    @auth.url = @auth.url + '/'
    @_findUser(success, error)


  ###
   Load time entry activities.
  ###
  getActivities: (success, error) ->
    config =
      method: "GET"
      url: @auth.url + "/enumerations/time_entry_activities.json"
    config = @setBasicConfig config, @auth
    @$http(config)
      .success( (data, status, headers, config) =>
        data.url = @auth.url
        success?(data, status, headers, config))
      .error(error or @NULLFUNC)
