#= require jquery
#= require jquery_ujs
init = ->
  myMap = new (ymaps.Map)('map',
    center: [55.74, 37.58]
    zoom: 11
    controls: []
  )

  myMap.events.add 'click', (e) ->
    myMap.geoObjects.removeAll()

    circleGeometry = new (ymaps.geometry.Circle)(
      e.get('coords')
      5000
    )

    myCircle = new (ymaps.GeoObject)(
      geometry: circleGeometry
    )

    myMap.geoObjects.add myCircle

    ymaps.search(
      'кафе'
      results: 50
      boundedBy: circleGeometry.getBounds()
    ).then (result) ->
      result.geoObjects.each (el, i) ->
        myMap.geoObjects.add(el) if circleGeometry.contains el.geometry.getCoordinates()

ymaps.ready init



