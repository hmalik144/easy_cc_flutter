package com.appttude.h_mal.easycc

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
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
                val from: String? = widgetData.getString("from", null)
                val to: String? = widgetData.getString("to", null)
                val rate: String? = widgetData.getString("rate", null)

                val titleString = "${from}${to}"
                setTextViewText(R.id.exchangeName, titleString)
                setTextViewText(R.id.exchangeRate, rate.toString())

                val uri = Uri.parse("myAppWidget://update")
                uri.buildUpon().query(widgetId.toString()).build()

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
}