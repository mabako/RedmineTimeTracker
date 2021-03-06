timeTracker.value "TestData", ()->

  SHOW = { DEFAULT: 0, NOT: 1, SHOW: 2 }

  return {

    prj1: [
      {
        url: "http://redmine.com"
        urlIndex: 0
        id: 0
        text: "prj1_0"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com"
        urlIndex: 0
        id: 1
        text: "prj1_1"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com"
        urlIndex: 0
        id: 2
        text: "prj1_2"
        show: SHOW.DEFAULT
      }
    ]

    prj2: [
      {
        url: "http://redmine.com2"
        urlIndex: 1
        id: 0
        text: "prj2_0"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com2"
        urlIndex: 1
        id: 1
        text: "prj2_1"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com2"
        urlIndex: 1
        id: 2
        text: "prj2_2"
        show: SHOW.DEFAULT
      }
    ]

    prj3: [
      {
        url: "http://redmine.com3"
        urlIndex: 2
        id: 0
        text: "prj3_0"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com3"
        urlIndex: 2
        id: 1
        text: "prj3_1"
        show: SHOW.DEFAULT
      }, {
        url: "http://redmine.com3"
        urlIndex: 2
        id: 2
        text: "prj3_2"
        show: SHOW.DEFAULT
      }
    ]

    prjObj:
      "http://redmine.com" :
        index: 0
        0:
          text: "prj1_0"
          show: SHOW.DEFAULT
      "http://redmine.com2" :
        index: 1
        0:
          text: "prj2_0"
          show: SHOW.DEFAULT
      "http://redmine.com3" :
        index: 2
        0:
          text: "prj3_0"
          show: SHOW.DEFAULT

    prjOldFormat:                                     # version <= 0.5.7
      "http://redmine.com" :
        index: 2
        0:
          text: "prj1_0"
          show: SHOW.DEFAULT
      "http://redmine.com2" :
        index: 3
        0:
          text: "prj2_0"
          show: SHOW.DEFAULT
      "http://redmine.com3" :
        index: 4
        0:
          text: "prj3_0"
          show: SHOW.DEFAULT

    ticketList: [
      {
        id: 0,
        text: "ticket0",
        url: "http://redmine.com",
        project:
          id: 0
          text: "prj1_0",
        show: SHOW.DEFAULT
      }, {
        id: 1,
        text: "ticket1",
        url: "http://redmine.com",
        project:
          id: 0
          text: "prj1_0",
        show: SHOW.NOT
      }, {
        id: 2,
        text: "ticket2",
        url: "http://redmine.com",
        project:
          id: 0
          text: "prj1_0",
        show: SHOW.SHOW
      }
    ]

    ticketList2: [
      {
        id: 0,
        text: "ticket0",
        url: "http://redmine.com",
        project:
          id: 0
          text: "prj1_0",
        show: SHOW.DEFAULT
      }, {
        id: 0,
        text: "ticket2",
        url: "http://redmine.com2",
        project:
          id: 0
          text: "prj2_0",
        show: SHOW.NOT
      }, {
        id: 0,
        text: "ticket3",
        url: "http://redmine.com3",
        project:
          id: 0
          text: "prj3_0",
        show: SHOW.SHOW
      }
    ]

    ticketOnChrome: [
      # id | text      | url_index | prj_id |    show
      [ 0,  "ticket0",      0,         0,     SHOW.DEFAULT ],
      [ 0,  "ticket2",      1,         0,     SHOW.NOT     ],
      [ 0,  "ticket3",      2,         0,     SHOW.SHOW    ]
    ]

    queries: {
      "queries": [{"id":0, "name":"aaa", "is_public":true}, {"id":2, "name":"bbb"}]
      "total_count":2
      "offset":0
      "limit":25
    }

    user: {
      "user":{
        "id":1
        "login":"admin"
        "firstname":"Redmine"
        "lastname":"Admin"
        "mail":"test@gmail.com"
        "created_on":"2013-08-22T14:24:27Z"
      }
    }

  }
