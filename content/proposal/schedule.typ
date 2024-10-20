= Schedule
#table(
  columns: 5,
  [*\#*], [*Tasks*], [*Objective*],[*Responsible Person*], [*Duration*],
  [1], [UI Consistency Review and Initial Redesign for Apollon Web], [4.1],[Ege Nerse], [3 weeks],
  [2] ,[UI Consistency Review and Initial Redesign for Apollon Ios Application and Apollon-Ios-Module], [4.1],[Belemir Kürün], [3 weeks],
  [3], [Bug Fixes: Resizing, Alignment, and Integration Issues for Apollon Web ], [4.2],[Ege Nerse], [4 weeks],
  [4], [Bug Fixes: Child Element Placing, Alignment and Drag-Drop Issues for Apollon Ios Application], [4.2],[Belemir Kürün], [4 weeks],
  [5], [Implement and Test New UI Components for Apollon Web], [4.2, 4.3], [Ege Nerse],[4 weeks],
  [6], [Implement and Test New UI Components for Ios App], [4.2, 4.3], [Belemir Kürün],[4 weeks],
  [7], [Development of Additional Features According to Gathered Feedback for Apollon Web], [4.3], [Ege Nerse],[3 weeks],
  [8], [Development of Additional Features According to Gathered Feedback for Apollon Ios Application], [4.3], [Belemir Kürün],[3 weeks],
  [9], [Usability Testing and Feedback Collection (Web and iOS)], [4.4], [Ege Nerse - Belemir Kürün],[3 weeks],
  [10],[Final Implementation, Testing, and Refinement for Apollon Web], [4.2, 4.3], [Ege Nerse], [3 weeks],
  [11],[Final Implementation, Testing, and Refinement for Apollon Ios Application], [4.2, 4.3], [Belemir Kürün], [3 weeks],
  [12], [Thesis Writing and Final Presentation Preparation], [], [Ege Nerse - Belemir Kürün], [4 weeks]
)

#import "@preview/timeliney:0.1.0"

#timeliney.timeline(
  show-grid: true,
  {
    import timeliney: *

    headerline(group(([Oct], 2)), group(([Nov], 2)), group(([Dec], 2)), group(([Jan], 2)), group(([Feb], 2)), group(([Mar], 2)), group(([Apr], 2)))

    taskgroup(title: [*Redesign*], {
      task("Initial Web redesign", (1, 2.5), style: (stroke: 2pt + gray))
      task("Initial iOS redesign", (1, 2.5), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Bug Fixing*], {
      task("Web Bug Fixes", (2.5, 4.5), style: (stroke: 2pt + gray))
      task("iOS Bug Fixes", (2.5, 4.5), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Feedback and Feature Implementation*], {

      task("Web Feedback Collection", (4.5, 5), style: (stroke: 2pt + gray))
      task("iOS Feedback Collection", (4.5, 5), style: (stroke: 2pt + gray))

      task("Web Feature Implementation", (5, 7), style: (stroke: 2pt + gray))
      task("iOS Feature Implementation", (5, 7), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Feedback Collection & Iteration*], {
      task("Web Feedback Collection II", (7, 7.5), style: (stroke: 2pt + gray))
      task("iOS Feedback Collection II", (7, 7.5), style: (stroke: 2pt + gray))
      task("Further Web Development", (7.5, 9.0), style: (stroke: 2pt + gray))
      task("Further Ios Development", (7.5, 9.0), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Feedback Collection & Final Implementation*], {
      task("Web Feedback Collection III", (9.0, 9.5), style: (stroke: 2pt + gray))
      task("iOS Feedback Collection III", (9.0, 9.5), style: (stroke: 2pt + gray))
      task("Final Implementation for Apollon Web", (9.5, 11.0), style: (stroke: 2pt + gray))
      task("Final Implementation for Apollon Ios", (9.5, 11.0), style: (stroke: 2pt + gray))
    })

    taskgroup(title: [*Finalization and Documentation*], {
      task("Finalization & Documentation", (11.0, 13), style: (stroke: 2pt + gray))
    })



  }
)
