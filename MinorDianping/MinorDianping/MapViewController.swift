//
//  MapViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/10.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mainMapView: MKMapView!
    var restaurant: Restaurant?

    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = restaurant?.name
        
        //经纬度+comment
        let localLatitude = restaurant?.latitude
        let localLongitude = restaurant?.longitude
        let localComment = restaurant?.comments
        
        //使用代码创建
        self.mainMapView = MKMapView(frame:self.view.frame)
        self.view.addSubview(self.mainMapView)
        self.mainMapView.delegate = self
        
        //地图类型设置 - 标准地图
        self.mainMapView.mapType = MKMapType.standard
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用当前位置
        //var center:CLLocation = locationManager.location.coordinate
        //使用自定义位置
        let center:CLLocation = CLLocation(latitude: localLatitude!, longitude: localLongitude!)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                  span: currentLocationSpan)
        
        //设置显示区域
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = CLLocation(latitude: localLatitude!,
                                                 longitude: localLongitude!).coordinate
        //设置点击大头针之后显示的标题
        objectAnnotation.title = restaurant?.name
        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle = localComment
        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation)
    }
    
    
    @IBAction func navButton(_ sender: UIBarButtonItem) {
        //define destination
        let latitude:CLLocationDegrees = (restaurant?.latitude)!
        let longitude:CLLocationDegrees = (restaurant?.longitude)!
        
        let regionDistance:CLLocationDistance = 1000
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant?.name
        mapItem.openInMaps(launchOptions: options)
    }
}
