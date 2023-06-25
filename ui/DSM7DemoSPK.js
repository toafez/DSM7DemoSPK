Ext.namespace("SYNO.SDS.DSM7DemoSPK.Utils");

Ext.define("SYNO.SDS.DSM7DemoSPK.Application", {
    extend: "SYNO.SDS.AppInstance",
    appWindowName: "SYNO.SDS.DSM7DemoSPK.MainWindow",
    constructor: function() {
        this.callParent(arguments);
    }
});

Ext.define("SYNO.SDS.DSM7DemoSPK.MainWindow", {
    extend: "SYNO.SDS.AppWindow",
    constructor: function(a) {
        this.appInstance = a.appInstance;
        SYNO.SDS.DSM7DemoSPK.MainWindow.superclass.constructor.call(this, Ext.apply({
            layout: "fit",
            resizable: true,
            cls: "syno-app-win",
            maximizable: true,
            minimizable: true,
            width: 1024,
            height: 768,
            html: SYNO.SDS.DSM7DemoSPK.Utils.getMainHtml()
        }, a));
        SYNO.SDS.DSM7DemoSPK.Utils.ApplicationWindow = this;
    },

    onOpen: function() {
        SYNO.SDS.DSM7DemoSPK.MainWindow.superclass.onOpen.apply(this, arguments);
    },

    onRequest: function(a) {
        SYNO.SDS.DSM7DemoSPK.MainWindow.superclass.onRequest.call(this, a);
    },

    onClose: function() {
        clearTimeout(SYNO.SDS.DSM7DemoSPK.TimeOutID);
        SYNO.SDS.DSM7DemoSPK.TimeOutID = undefined;
        SYNO.SDS.DSM7DemoSPK.MainWindow.superclass.onClose.apply(this, arguments);
        this.doClose();
        return true;
    }
});

Ext.apply(SYNO.SDS.DSM7DemoSPK.Utils, function() {
    return {
        getMainHtml: function() {
            // Timestamp must be inserted here to prevent caching of iFrame
            return '<iframe src="webman/3rdparty/DSM7DemoSPK/index.cgi?timestamp=' + new Date().getTime() + '" title="react-app" style="width: 100%; height: 100%; border: none; margin: 0"/>';
        },
    }
}());