= Mobile Application Support and Usability Improvements

In recent years, mobile devices have become essential tools for both formal education and self-directed learning. Students frequently use smartphones and tablets to complete tasks, review materials, and collaborate with peers, especially in remote or hybrid learning contexts. Studies have shown that mobile learning increases flexibility and accessibility, improving engagement and learning outcomes across diverse student groups [@denoyelles2023evolving].

Ensuring that educational tools like Apollon work seamlessly across all platforms — including desktops, tablets, and phones — enhances their usability and relevance. Platform consistency allows students to switch between devices without facing different interfaces, behaviors, or limitations. This consistency improves productivity and reduces the cognitive load associated with context switching, especially when learning complex modeling tasks [@mendel2009interface].

Furthermore, mobile support benefits instructors and developers by making the application available in a wider range of usage scenarios — from classroom demonstrations to on-the-go corrections and feedback. Enabling cross-platform access is not just a matter of convenience but a requirement for inclusive and future-proof educational software.

= Capacitor-Based Mobile Integration

#align(left)[
  #text(size: 10pt)[Belemir Kürün]
]

== Limitations of the Previous iOS Application

The earlier version of Apollon attempted to support mobile platforms by maintaining a separate iOS application in a different repository. However, this approach came with multiple limitations. The iOS app suffered from severe rendering issues — when users moved nodes on the canvas, text such as class names, attributes, or methods often shifted away from their designated positions. This was caused by inconsistencies in how coordinate translations were handled during drag interactions on iOS devices, especially in combination with scaling and zooming.

#figure(
  image("../figures/classDiagramBug.jpeg", width: 90%),
  caption: [Node Translation Bug in current iOS Apollon Application]
)

Maintaining a separate codebase also became a burden. Every update made to the web version had to be mirrored manually in the iOS repository, leading to duplicated efforts and a growing risk of divergence between the two platforms. Additionally, this approach completely excluded Android users, leaving a significant portion of the student base unsupported.

Even mobile web browsers, which seemed like a fallback, posed major usability problems. Touch-based interactions, such as dragging nodes or creating edges, were unreliable. Often, attempts to create edges would result in accidental scrolling, breaking the modeling flow. The large sidebar occupying a substantial portion of the screen further reduced the usable diagram space, making it impractical to perform meaningful tasks on a phone or tablet. Collectively, these issues made the mobile experience inconsistent, buggy, and largely unusable for students and instructors who needed quick access to modeling tasks outside a desktop environment.

== Introducing Capacitor for Cross-Platform Support

To resolve these issues, we introduced *Capacitor* #footnote[https://capacitorjs.com] as a solution for cross-platform mobile development. Capacitor is a runtime that allows modern web applications, including React apps, to be bundled and deployed as native applications for both iOS and Android. Unlike previous attempts at native apps, this approach allowed us to maintain a single shared codebase for the web, iOS, and Android platforms, drastically reducing the maintenance overhead.

Using Capacitor, we wrapped the Apollon Standalone Webapp and deployed it to both the Apple App Store and Google Play Store. Capacitor acts as a bridge between the web and native environments, enabling direct access to native APIs while preserving the core modeling functionalities implemented in React. This approach ensured consistent behavior across platforms and eliminated the need for fragmented implementations.

Moreover, the mobile web experience was also improved in the process. By embedding the application in a native container, we were able to better control gestures, scrolling, and touch input. This allowed for smoother interaction and addressed many of the previous shortcomings in browser-based mobile usage.

== Mobile Usability Improvements

#align(left)[
  #text(size: 10pt)[Belemir Kürün and Ege Nerse]
]
After introducing Capacitor, we focused on improving the mobile experience beyond simply making the application installable. Several refinements were made to enhance usability specifically for touch-based devices. The sidebar was redesigned to take up less screen space, giving users more room to interact with diagrams on smaller displays. Diagram elements within the sidebar were scaled appropriately so they remained usable even on compact phones.

Touch interaction was overhauled to ensure compatibility with both fingers and styluses such as the Apple Pencil. Drag-and-drop behavior was optimized to reduce accidental scrolling, and edge creation became more intuitive. We increased the size of connection ports on diagram nodes, which made it significantly easier to link elements using touch gestures.

These improvements make the mobile version of Apollon not only functional, but also practical for real-world usage. Students can now comfortably create, edit, and submit diagrams on their phones or tablets, whether during lab sessions, on the move, or during last-minute revisions.
