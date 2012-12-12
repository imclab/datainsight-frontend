describe("scatterplot", function () {
    beforeEach(function () {
        this.scatterplot = GOVUK.Insights.scatterplotGraph();
        this.data = [
            {x: 100000, y: 200, colour: 200, label: "this is 200"},
            {x: 50000, y: 300, colour: 300, label: "this is 300"},
            {x: 5000, y: 400, colour: 400, label: "this is 400"}
        ];
        this.stubGraphElement = $('<div id="scatterplot"></div>');
        this.stubGraphElement.clone().appendTo("body");
    });
    afterEach(function () {
        $("#scatterplot").remove();
    });
    describe("setters and getters", function () {
        it("should set and get", function () {
            expect(this.scatterplot.width()).toEqual(960);
            this.scatterplot.width(500);
            expect(this.scatterplot.width()).toEqual(500);
        });
    });

    describe("rendering the graph", function () {
        it("should not raise an error", function () {
            d3.select('#scatterplot')
                .datum(this.data)
                .call(this.scatterplot);
        });
    });

    describe("rendering the legend", function () {
        beforeEach(function () {
            this.renderScatterplot = function () {
                d3.select("#scatterplot")
                    .datum(this.data)
                    .call(this.scatterplot.legend);
            };
        });


        it("should not raise an error", function () {
            this.renderScatterplot();
        });

        it("should add an svg element", function () {
            this.renderScatterplot();

            expect(d3.select("#scatterplot svg").node()).toBeTruthy();
        });

        it("should add exactly two text labels", function () {
            this.renderScatterplot();

            expect(d3.selectAll("#scatterplot text")[0].length).toEqual(2);
        });

        it("should add a text element with 20k times used", function () {
            this.renderScatterplot();

            var textElement = d3.selectAll("#scatterplot text")[0][0];
            expect(textElement).toBeTruthy();
            expect(d3.select(textElement).text()).toEqual("20k times used");
        });

        it("should add a text element with 60k times used", function() {
            this.renderScatterplot();

            var textElement = d3.selectAll("#scatterplot text")[0][1];
            expect(textElement).toBeTruthy();
            expect(d3.select(textElement).text()).toEqual("60k times used");
        });

        it("should add a circle with radius 580001", function () {
            this.renderScatterplot();

            var circleElement = d3.selectAll("#scatterplot circle")[0][0];
            expect(circleElement).toBeTruthy();
            expect(d3.select(circleElement).attr("r")).toEqual("580001");
        });

        it("should add a circle with radius 1740001", function () {
            this.renderScatterplot();

            var circleElement = d3.selectAll("#scatterplot circle")[0][1];
            expect(circleElement).toBeTruthy();
            expect(d3.select(circleElement).attr("r")).toEqual("1740001");
        });
    });
});