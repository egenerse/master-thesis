#import "/utils/todo.typ": TODO

= Summary
#TODO[
  This chapter includes the status of your thesis, a conclusion and an outlook about future work.
]

This chapter summarizes what goals have been implemented as part of this thesis. We will discuss which goals have not or only been partially fulfilled and what is required to complete them. Furthermore we will mention future work which will improve the Apollon and Artemis Modelling Exercises in the future.

== Status
#TODO[
  Describe honestly the achieved goals (e.g. the well implemented and tested use cases) and the open goals here. if you only have achieved goals, you did something wrong in your analysis.
]
This section explains the current status of the Apollon Reengineering and Artemis Integration. To evaluate which goals have been fulfilled and what still needs to be improved we assign the goals one of the following letters.

I : Implemented
HI: Half Implemented
N: Not Implemented

All requirements defined in Section 4.2 and their status are listed in @statusTable.
#figure(
  table(
    columns: 3,
    align: (left, center, center),
    table.cell(colspan: 2)[*Requirements*], [*Status*],
[FR1], [Artemis Compatibility], [HI],
[FR2], [Unified Monorepo Structure], [I],
[FR3], [Mobile Application Support], [I],
[FR4], [Diagram Functionality], [I],
[FR5], [Full Diagram Type Support], [HI],
[FR6], [Client-Side WebSocket Management for Collaborative Editing], [I],
[FR7], [Collaboration Traﬃc Limit], [I],

[QA1], [Usability], [HI],
[QA2], [Maintainability], [I],
[QA3], [Performance], [I],
[QA4], [Accessibility], [I],
  ),
  caption: [Requirements Status Table]
)<statusTable>


=== Realized Goals
#TODO[
  Summarize the achieved goals by repeating the realized requirements or use cases stating how you realized them.
]

This section summarizes the current status of implemented requirements and achieved goals.

We successfully implemented the Apollon Reengineering Library, along with the Webapp and Server components of the Apollon Standalone. This satisfies FR1 and FR2. The reengineered library maintains the full feature set of the previous version while introducing a cleaner mono-repo structure, where both the library and standalone application coexist in a shared repository. The new architecture follows modern React development practices, significantly improving maintainability and thereby fulfilling QA2.

The Webapp and Server together enable users to model diagrams without requiring registration. Users can share links and collaborate in real time. This streamlined setup ensures a frictionless modeling experience while preserving collaboration functionality.

We also completed the initial integration with Artemis. Core workflows such as diagram creation, submission, collaboration, feedback, and review are fully supported. However, features like selecting or highlighting individual methods or attributes are still missing. Therefore, FR3 is partially fulfilled.

Additionally, we integrated Capacitor into the mono-repo, enabling us to deploy the latest changes directly to native iOS and Android apps. Touch-based events and gestures were handled carefully to improve the mobile experience across both apps and browsers. These improvements fulfill FR4 and also improves Acesibility which was the QA4.

All previously available modeling features remain intact, successfully fulfilling FR5. Moreover, we began extending support for additional diagram types. While not all types are supported yet, this partially meets the requirement of FR6.

We reintroduced collaboration mode using the same WebSocket-based infrastructure, fulfilling FR7. We ensured the collaboration traffic stays well below the 200 KB threshold currently under 100 KB. This demonstrates that the system can support larger collaboration sessions which fulfills QA3 (Performance)

Finally, based on feedback gathered during testing, we implemented several usability improvements such as a minimap, zoom controls, and refined UI icons. These enhancements contribute toward meeting QA1 (Usability) and ensure a more intuitive user experience.

=== Open Goals
#TODO[
  Summarize the open goals by repeating the open requirements or use cases and explaining why you were not able to achieve them. Important: It might be suspicious, if you do not have open goals. This usually indicates that you did not thoroughly analyze your problems.
]

Despite successfully implementing many of the planned features, several requirements remain partially or fully open.

Most features from the old version of the library are included in the new one, but we are still missing some, such as dark mode, German language support, and diagram history. Also, diagram types like BPMN, Flow Chart, and Syntax Tree, which existed in the old Apollon, are no longer supported. These can be added in the future, but due to limited time, we focused on core UML diagrams, and left the others in the backlog.

Artemis Integration (FR1) has not yet reached full completion. The drag-and-drop feedback functionality is still missing, primarily because the system lacks proper support for tracking highlighted elements. In order to assign feedback to individual diagram elements, especially attributes or methods within class diagrams, we need to implement a mechanism that tracks which parts of the diagram users highlight.

Similarly, tracking selected elements is missing too. This is important for Drag and Drop Apollon Modeling quizzes in Artemis, where instructors can include or exclude specific elements or their details (like methods or attributes) when creating quizzes. At the moment, our SVG rendering system can not include or exclude selected parts in interactive mode. However, this does not block the drag and drop quiz feature completely. Instructors can still create quiz boxes by cropping the PNG image of the correct solution model.

We also identified additional usability issues based on the feedback collected from testing sessions. While we introduced improvements such as a minimap, zoom controls, and mobile compatibility, we have not yet implemented critical UI features like a more intuitive navigation bar or helper lines to assist with alignment and layout. These missing components limit our ability to fully satisfy QA1 (Usability).

In terms of accessibility, we still need to address multiple areas. We we need to make edge creation better and easier for mobile users while making icons and handles bigger.By addressing these accessibility improvements, we will make the tool more inclusive and bring us closer to meeting QA4 (Accessibility) in future iterations.

In summary, while the current version of Apollon meets many of its functional goals, we still need to complete important integration and usability features to fully realize the tool’s potential in an educational context.



== Conclusion
#TODO[
  Recap shortly which problem you solved in your thesis and discuss your *contributions* here.
]

In this thesis, we reengineered the entire Apollon diagramming library, transforming it into a modern, maintainable, and scalable mono-repo architecture. We simplified the internal structure to make future development such as debugging, feature expansion, and usability testing easier.

We updated the entire codebase to align with current React standards by replacing legacy class-based components with functional components and adopting modern tools like Zustand for state management. We also integrated React Flow, a powerful diagramming library, which enabled us to handle complex node and edge interactions with less effort and cleaner abstractions.

Beyond architectural improvements, we also focused on enhancing usability. We introduced features such as infinite canvas navigation and more intuitive interactions such as ghost edge connection. However, the most substantial improvements came in mobile support. The previous version of Apollon was nearly unusable on mobile devices due to severe bugs in both the standalone web app and the iOS application. With the reengineered version now powered by Capacitor for native deployment we offer a consistent, touch-friendly experience across iOS, Android, and mobile browsers. Students can now create and edit diagrams directly from their mobile devices, which greatly improves accessibility and flexibility.

Overall, this thesis contributes a fully modernized and platform consistent diagramming solution that addresses long standing limitations in Apollon and prepares it for continued use within educational platforms like Artemis and beyond.

== Future Work


While this thesis introduced a reengineered version of Apollon with a modern architecture and improved user experience, several areas offer promising directions for future work to further expand its capabilities, accessibility, and usability.

One of the most impactful areas of future development lies in enhancing real time collaboration. Adding support for live mouse movement tracking, each with individual colors and user labels, would allow users to see who is working on what part of the diagram in real time. This would improve awareness, reduce conflicts, and encourage better teamwork. Furthermore, supporting features like live cursors name labels could make group modeling sessions more interactive and organized.

Aligning elements with equal height and consistent spacing would also be a valuable addition, as alignment becomes challenging when working with many elements. Implementing helper lines could further enhance this functionality, making it easier to create professional looking diagrams.

Adding suggestion when user hover handle to create fast edge and a new diagram element would also improve usability. This feature would provide users with quick access to commonly used actions, reducing the number of clicks required to perform tasks and making the modeling process more efficient.

