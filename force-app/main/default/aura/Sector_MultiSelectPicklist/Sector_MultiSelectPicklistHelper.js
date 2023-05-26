({
    init: function(component) {
        // Load some default values.
        component.set("v.allOptions", [
            { value: "CAISO", label: "CAISO" },
            { value: "ERCOT", label: "ERCOT" },
            { value: "SPP", label: "SPP" },
            { value: "MISO", label: "MISO" },
            { value: "PJM", label: "PJM" },
            { value: "NYISO", label: "NYISO" },
            { value: "Other", label: "Other" }
        ]);
        // Initialize the options list
        this.search(component);
    },
    search: function(component) {
        // Search term
        var term = component.get("v.term");
        // Show all when no filter, or when filter matches label or value
        component.set("v.options",
                      component.get("v.allOptions")
                      .filter(
                          item => !term || 
                          item.value.match(term) || 
                          item.label.match(term)));
    }
})