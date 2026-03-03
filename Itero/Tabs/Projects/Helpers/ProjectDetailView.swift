//
//  ProjectDetailView.swift
//  Itero
//
//  Created by Filippo Cilia on 02/03/2026.
//

import SwiftUI

struct ProjectDetailView: View {
    @State private var isEditing: Bool = false

    let project: Project

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let title = project.title {
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.primary)
                }
                if let details = project.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }

                GroupBox("Info") {
                    LabeledContent("Status", value: project.status?.title ?? "Unknown")
                    LabeledContent("Priority", value: project.priority?.title ?? "Normal")

                    if let startDate = project.startDate {
                        LabeledContent("Start Date") {
                            Text(startDate, format: .dateTime.month().day().year())
                        }
                    }

                    if let dueDate = project.dueDate {
                        LabeledContent("Due Date") {
                            Text(dueDate, format: .dateTime.month().day().year())
                        }
                    }
                }
                .padding(.bottom)

                // TODO: make these tappable like todo's in notes
                if let tasks = project.tasks, !tasks.isEmpty {
                    Text("Tasks")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    ForEach(tasks) { task in
                        Button(action: {
                            toggleTaskCompletion(for: task)
                        }) {
                            HStack {
                                Image(systemName: isTaskDone(for: task) ? "checkmark.circle" : "circle")
                                    .foregroundStyle(isTaskDone(for: task) ? .green : .secondary)
                                    .symbolEffect(.bounce, value: isTaskDone(for: task))
                                Text(task.title)
                                    .foregroundStyle(isTaskDone(for: task) ? .secondary : .primary)
                                    .strikethrough(isTaskDone(for: task), color: .secondary)
                                    .multilineTextAlignment(.leading)
                                if task.status != .done {
                                    Spacer(minLength: 8)
                                    Text(task.status.title.uppercased())
                                        .font(.caption2)
                                        .bold()
                                        .contentTransition(.numericText())
                                        .padding(4)
                                        .background(badgeColor(for: task).opacity(0.5))
                                        .clipShape(.rect(cornerRadius: 4, style: .continuous))
                                }
                            }
                            .padding(4)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "square.and.pencil") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditProjectDetails(project: project)
        }
    }

    private func badgeColor(for task: ProjectTask) -> Color {
        switch task.status {
        case .inProgress:
            return .yellow
        default:
            return .secondary
        }
    }

    private func isTaskDone(for task: ProjectTask) -> Bool {
        return task.status == .done
    }

    private func toggleTaskCompletion(for task: ProjectTask) {
        withAnimation(.snappy) {
            switch task.status {
            case .notStarted:
                task.status = .inProgress
            case .inProgress:
                task.status = .done
            case .done:
                task.status = .notStarted
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProjectDetailView(project: SampleData.makeProjects()[0])
    }
}
