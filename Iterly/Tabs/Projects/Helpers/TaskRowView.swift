//
//  TaskRowView.swift
//  Iterly
//
//  Created by Filippo Cilia on 05/03/2026.
//

import SwiftUI

struct TaskRowView: View {
    let task: ProjectTask
    let isTaskDone: Bool
    let toggleTaskCompletion: () -> Void

    var body: some View {
        let isDone = isTaskDone

        HStack(alignment: .firstTextBaseline) {
            Button(
                "Toggle Status",
                systemImage: isDone ? "checkmark.circle" : "circle"
            ) {
                toggleTaskCompletion()
            }
            .labelStyle(.iconOnly)
            .foregroundStyle(isDone ? .green : .secondary)
            .symbolEffect(.bounce, value: isDone)
            .buttonStyle(.plain)

            NavigationLink(value: task.id) {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .foregroundStyle(isDone ? .secondary : .primary)
                        .strikethrough(isDone, color: .secondary)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("Due: ") +
                        Text(
                            task.dueDate,
                            format: .dateTime.day().month().year()
                        )
                        .bold()
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)

            Menu {
                Picker("Status", selection: Binding(
                    get: { task.status },
                    set: { task.status = $0 }
                )) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.title)
                            .tag(status)
                    }
                }
            } label: {
                Text(task.status.title)
                    .badgeStyle(backgroundColor: task.status.backgroundColor)
            }
            .buttonStyle(.plain)
        }
        .padding(4)
    }
}

#Preview {
    TaskRowView(
        task: SampleData.makeProjects()[0].tasks?[0] ?? .init(project: SampleData.makeProjects()[0]),
        isTaskDone: false,
        toggleTaskCompletion: {
        }
    )
}
