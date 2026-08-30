import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.ecommerce.dev"
            resValue(type = "string", name = "app_name", value = "App Dev")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.ecommerce.staging"
            resValue(type = "string", name = "app_name", value = "App Staging")
        }
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.ecommerce"
            resValue(type = "string", name = "app_name", value = "E-Commerce")
        }
    }

    buildFeatures.resValues = true
}