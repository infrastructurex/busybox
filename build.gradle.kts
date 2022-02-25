val busyboxVersion: String by project
val arch = System.getenv("ARCH") ?: "x64"
val dockerArch = System.getenv("DOCKER_ARCH") ?: "amd64"
val githubRunNumber = System.getenv("GITHUB_RUN_NUMBER") ?: "0-SNAPSHOT"

group = "io.vmify.nanoos"
version = "${busyboxVersion}-$githubRunNumber"

plugins {
    id("maven-publish")
}

repositories {
    mavenCentral()
}

val buildBusybox by tasks.registering(Exec::class) {
    commandLine(
        "docker",
        "buildx",
        "build",
        "--build-arg",
        "BUSYBOX_VERSION=$busyboxVersion",
        "--platform=linux/$dockerArch",
        "--output",
        "type=local,dest=${project.buildDir.absolutePath}/jar",
        "."
    )
}

val archJar by tasks.registering(Jar::class) {
    dependsOn(buildBusybox)

    destinationDirectory.set(project.buildDir)
    archiveBaseName.set("busybox-$arch")
    archiveVersion.set(project.version.toString())
    from("${project.buildDir.absolutePath}/jar")
}

val build by tasks.registering {
    dependsOn(archJar)
}

publishing {
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/vmify/busybox")
            credentials {
                username = System.getenv("GITHUB_ACTOR")
                password = System.getenv("GITHUB_TOKEN")
            }
        }
    }

    publications {
        create<MavenPublication>("archJar") {
            artifact(archJar)
        }
    }
}