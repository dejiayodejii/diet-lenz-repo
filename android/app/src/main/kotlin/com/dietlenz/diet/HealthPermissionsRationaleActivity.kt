package com.dietlenz.diet

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle

class HealthPermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        startActivity(
            Intent(
                Intent.ACTION_VIEW,
                Uri.parse(PRIVACY_POLICY_URL),
            ),
        )
        finish()
    }

    private companion object {
        const val PRIVACY_POLICY_URL = "https://dietlenz.com/privacy"
    }
}
