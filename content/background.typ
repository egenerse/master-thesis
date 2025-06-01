#import "/utils/todo.typ": TODO

= Background
// Describe each proven technology / concept shortly that is important to understand your thesis.
// Point out why it is interesting for your thesis.

Apollon is a UML diagram editor developed by the Chair of Applied Software Engineering at TUM. It supports a wide range of diagram types including class, activity, use case, component, and object diagrams. Apollon is used in both learning and modeling contexts to help users visualize software systems.

== Apollon Library

The Apollon UML editor is available as an NPM package under the name `@ls1intum/apollon`. This package provides a React-based editor component that can be integrated into web applications. It allows users to create and export diagrams in SVG, PNG, and PDF formats and supports various UML types through configuration.

The Apollon library is integrated into the Artemis platform, where students use it to complete modeling exercises and exams. Instructors use the same integration for assessment purposes. The library communicates with Artemis using a JSON-based format that defines the diagram structure and content.

== Apollon Standalone

In addition to its use within Artemis, Apollon is also offered as a standalone web application accessible at [apollon.ase.in.tum.de](https://apollon.ase.in.tum.de). This version allows students to create UML diagrams independently of Artemis. It is useful for preparing designs outside class, practicing for exams, or creating UML diagrams for reports and assignments.

The standalone version is based on the same codebase as the library and offers the same core features in a browser-accessible interface.

== Collaboration Mode in Apollon

Apollon also includes a collaboration mode that enables multiple users to edit the same diagram in real time. This feature is powered by **Yjs**, a shared editing framework based on operational transforms.

The collaboration mode was first introduced in a previous thesis by Eugene Okafor [@okafor2022collaboration]. In that work, a patch-based synchronization system was implemented to ensure consistent updates between users. The system supports collaborative editing of diagram elements while maintaining a shared state and resolving conflicts during concurrent edits.

This background is important for understanding the technical starting point of Apollon and how its existing architecture supports both individual and collaborative usage.
