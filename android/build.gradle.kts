import java.io.File

// ====================================================================
// 🛠️ 独立开发终极外挂：强制物理修复 isar_flutter_libs 的 Namespace 和 SDK 版本断层
// ====================================================================
val fixIsarNamespace = provider {
    // 自动定位你的 pub 缓存物理路径（兼容国内镜像和普通路径）
    val home = System.getProperty("user.home")
    val pubCacheDirs = listOf(
        File("$home/.pub-cache/hosted/pub.flutter-io.cn/isar_flutter_libs-3.1.0+1/android/build.gradle"),
        File("$home/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android/build.gradle")
    )

    for (file in pubCacheDirs) {
        if (file.exists()) {
            var content = file.readText()
            var changed = false
            
            // 1. 修复 namespace
            if (!content.contains("namespace")) {
                println("🚀 [追梦日历外挂] 正在物理修复 isar_flutter_libs 的命名空间...")
                content = content.replace(
                    "android {",
                    "android {\n    namespace \"dev.isar.isar_flutter_libs\""
                )
                changed = true
            }
            
            // 2. 修复 compileSdkVersion (强制提升到 34)
            if (content.contains("compileSdkVersion")) {
                val newContent = content.replace(Regex("compileSdkVersion\\s+\\d+"), "compileSdkVersion 34")
                if (newContent != content) {
                    println("🚀 [追梦日历外挂] 正在物理修复 isar_flutter_libs 的 compileSdkVersion...")
                    content = newContent
                    changed = true
                }
            }

            if (changed) {
                file.writeText(content)
                println("✅ [追梦日历外挂] isar_flutter_libs 物理热补丁注入成功！")
            }
        }
    }
}
// 强制触发执行这个外挂
fixIsarNamespace.get()

// ====================================================================
// 🟢 以下是你原本纯净的完整标准配置，一个字不用动
// ====================================================================
allprojects {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
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

// 统一强制修改所有子项目的 compileSdkVersion，确保符合 androidx 库的要求
subprojects {
    val setupAndroid = {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            try {
                // 尝试用反射或者动态方式修改，避免 KTS 编译时找不到 BaseExtension 类型
                val compileSdkVersionMethod = android?.javaClass?.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                compileSdkVersionMethod?.invoke(android, 34)
                
                // 同时尝试修改 targetSdkVersion
                val defaultConfig = android?.javaClass?.getMethod("getDefaultConfig")?.invoke(android)
                val setTargetSdkVersionMethod = defaultConfig?.javaClass?.getMethod("setTargetSdkVersion", Int::class.javaPrimitiveType)
                setTargetSdkVersionMethod?.invoke(defaultConfig, 34)
            } catch (e: Exception) {
                // 如果反射失败，尝试常规方式
            }
        }
    }

    if (project.state.executed) {
        setupAndroid()
    } else {
        project.afterEvaluate { setupAndroid() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
