package com.appttude.h_mal.easycc

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import android.widget.Toast
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider


class AppWidgetProvider : HomeWidgetProvider(){
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.currency_app_widget).apply {
                // Data from background operation received
                val from: String? = widgetData.getString("${widgetId}_from", null)
                val to: String? = widgetData.getString("${widgetId}_to", null)
                val rate: String? = widgetData.getString("${widgetId}_rate", null)

                if (from.isNullOrBlank() or to.isNullOrBlank() or rate.isNullOrBlank()) {
                    Toast.makeText(context, "Unable to review data for widget", Toast.LENGTH_SHORT).show()
                    return@apply
                }

                val titleString = "${from}${to}"
                setTextViewText(R.id.exchangeName, titleString)
                setTextViewText(R.id.exchangeRate, rate.toString())

                val uri = Uri.parse("myAppWidget://updatewidget").buildUpon()
                    .appendQueryParameter("id", widgetId.toString())
                    .build()

                setImageViewResource(R.id.refresh_icon, R.drawable.ic_refresh_white_24dp)
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, uri)
                setOnClickPendingIntent(R.id.refresh_icon, backgroundIntent)

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java)

                setOnClickPendingIntent(R.id.widget_view, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)

        when (intent?.action) {

        }
        val appWidgetManager = AppWidgetManager.getInstance(context);
        val appWidgetIds = appWidgetManager.getAppWidgetIds(
            context?.let { ComponentName(it, this::class.java) })
        val widgetDate = context?.let { HomeWidgetPlugin.getData(it) }

        appWidgetIds.forEach { widgetId ->


        }
    }

    override fun onDeleted(context: Context?, appWidgetIds: IntArray?) {
        super.onDeleted(context, appWidgetIds)

        appWidgetIds?.forEach { widgetId ->
            val uri = Uri.parse("myAppWidget://deletewidget")
            uri.buildUpon().appendQueryParameter("id", widgetId.toString()).build()

            context?.let {
                HomeWidgetBackgroundIntent
                    .getBroadcast(it, uri)
                    .send()
            }
        }
    }
}