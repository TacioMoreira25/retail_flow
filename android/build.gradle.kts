allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    fun fixNamespace() {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (android != null && android.namespace == null) {
            android.namespace = project.group.toString()
        }
    }

    if (project.state.executed) {
        fixNamespace()
    } else {
        project.afterEvaluate {
            fixNamespace()
        }
    }
}

subprojects {
    // Esta lógica verifica se chegamos "cedo" ou "tarde" e age de acordo
    val action = {
        val android = extensions.findByName("android")
        if (android != null) {
            // Força a versão 36 usando reflexão para funcionar em qualquer plugin
            try {
                val method = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                method.invoke(android, 36)
            } catch (e: Exception) {
                // Se der erro na reflexão, tenta pela propriedade compileSdk (plano B)
                try {
                    val property = android.javaClass.getMethod("setCompileSdk", Int::class.javaPrimitiveType)
                    property.invoke(android, 36)
                } catch (ignored: Exception) {}
            }
        }
    }

    if (state.executed) {
        action()
    } else {
        afterEvaluate { action() }
    }
}