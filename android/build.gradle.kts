plugins {
    // Versions set in individual modules to avoid resolution issues in monorepo
}

tasks.register("clean", Delete::class) {
    delete(layout.buildDirectory)
}

