package com.appttude.h_mal.easycc

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

/**
 * The configuration screen for the [CurrencyAppWidgetKotlin] AppWidget.
 */
class CurrencyAppWidgetConfigureActivity : Activity(),
    View.OnClickListener {

    private var mAppWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    private var top: String? = null
    private var bottom: String? = null

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.currency_app_widget_configure)

        // Set the result to CANCELED.  This will cause the widget host to cancel
        // out of the widget placement if the user presses the back button.
        setResult(RESULT_CANCELED)

        // Find the widget id from the intent.
        val extras = intent.extras
        if (extras != null) {
            mAppWidgetId = extras.getInt(
                AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID
            )
        }

        // If this activity was started with an intent without an app widget ID, finish with an error.
        if (mAppWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }
        setupClickListener()
    }

    private fun setupClickListener() {
        findViewById<TextView>(R.id.submitWidget).setOnClickListener(this)
        findViewById<TextView>(R.id.currencyOne).setOnClickListener(this)
        findViewById<TextView>(R.id.currencyTwo).setOnClickListener(this)
    }

    override fun onClick(view: View?) {
        when (view?.tag.toString()) {
            "top", "bottom" -> showCustomDialog(view)
            "submit" -> displaySubmitDialog()
        }
    }

    private fun displaySubmitDialog() {
        if (top == null || bottom == null) {
            Toast.makeText(this, "Selections incomplete", Toast.LENGTH_SHORT).show()
            return
        }
        if (top == bottom) {
            Toast.makeText(this, "Selected rates cannot be the same", Toast.LENGTH_SHORT).show()
            return
        }

        WidgetSubmitDialog(this, getSubmitDialogMessage(), object : DialogSubmit {
            override fun onSubmit() {
                sendUpdateIntent(top!!, bottom!!)
                finishCurrencyWidgetActivity()
            }
        }).show()
    }


    private fun showCustomDialog(view: View?) {
        CustomDialogClass(this) {
            (view as TextView).text = it
            when (view.tag.toString()) {
                "top" -> top = it
                "bottom" -> bottom = it
            }
        }.show()
    }

    fun finishCurrencyWidgetActivity() {
        // Make sure we pass back the original appWidgetId
        val resultValue = intent
        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, mAppWidgetId)
        setResult(RESULT_OK, resultValue)
        finish()
    }

    fun sendUpdateIntent(from: String, to: String) {
        // It is the responsibility of the configuration activity to update the app widget
        // Send update broadcast to widget app class
        val uri = Uri.parse("myAppWidget://createwidget").buildUpon()
            .appendQueryParameter("id", mAppWidgetId.toString())
            .appendQueryParameter("from", from)
            .appendQueryParameter("to", to)
            .build()

        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(this, uri)
        backgroundIntent.send()
    }

    private fun getSubmitDialogMessage(): String {
        val widgetName = getWidgetStringName()
        return StringBuilder().append("Create widget for ")
            .append(widgetName)
            .append("?").toString()
    }

    private fun getWidgetStringName() = "${top!!.substring(0, 3)}${bottom!!.substring(0, 3)}"

}
