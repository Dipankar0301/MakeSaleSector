({
    init: function(component) {
        // Load some default values.
        component.set("v.allOptions", [
            { value: "Hello", label: "Hello" },
            { value: "World", label: "World" },
            { value: "Test", label: "Test" }
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