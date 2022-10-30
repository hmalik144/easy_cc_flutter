package com.appttude.h_mal.easycc

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.widget.TextView


/**
 * Dialog created when submitting the completed selections
 * in [CurrencyAppWidgetConfigureActivity]
 */
class WidgetSubmitDialog(
    context: Context,
    private val messageString: String,
    private val dialogInterface: DialogSubmit
) : Dialog(context) {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.confirm_dialog)
        // layer behind dialog to be transparent
        window!!.setBackgroundDrawableResource(android.R.color.transparent)
        // Dialog cannot be cancelled by clicking away
        setCancelable(false)

        findViewById<TextView>(R.id.confirmText).text = messageString

        // handle dialog buttons
        findViewById<TextView>(R.id.confirmYes).setOnClickListener { dialogInterface.onSubmit() }
        findViewById<TextView>(R.id.confirmNo).setOnClickListener { dismiss() }
    }
}

interface DialogSubmit {
    fun onSubmit()
}