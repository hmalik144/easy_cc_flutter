package com.appttude.h_mal.easycc

import androidx.lifecycle.ViewModel
import com.appttude.h_mal.easycc.data.repository.Repository
import com.appttude.h_mal.easycc.ui.BaseViewModel
import com.appttude.h_mal.easycc.utils.trimToThree
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

class WidgetViewModel: ViewModel() {

    var appWidgetId: Int? = null

    var rateIdFrom: String? = null
    var rateIdTo: String? = null

    // Setup viewmodel app widget ID
    // Set default values for text views
    fun initiate(appId: Int) {
        appWidgetId = appId
    }

    // Retrieve name for submit dialog (eg. AUDGBP)
    fun getSubmitDialogMessage(): String {
        val widgetName = getWidgetStringName()
        return StringBuilder().append("Create widget for ")
            .append(widgetName)
            .append("?").toString()
    }

    fun submitSelectionOnClick() {
        if (rateIdTo == null || rateIdFrom == null) {
            onError("Selections incomplete")
            return
        }
        if (rateIdFrom == rateIdTo) {
            onError("Selected rates cannot be the same")
            return
        }
        onSuccess(Unit)
    }

    fun setWidgetStored() {

    }

    // Start operation based on dialog selection
    fun setCurrencyName(tag: Any?, currencyName: String) {
        when (tag.toString()) {
            "top" -> rateIdFrom = currencyName
            "bottom" -> rateIdTo = currencyName
        }
    }

    private fun getWidgetStringName() = "${rateIdFrom!!.substring(0, 3)}${rateIdTo!!.substring(0, 3)}"

}