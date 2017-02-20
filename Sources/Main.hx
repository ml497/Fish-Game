package;

import kha.System;
import kha.Scheduler;

class Main {
	public static function main() {
		System.init({title: "Project", width: 1024, height: 768}, function () {
			var shapes = new Project();
			System.notifyOnRender(shapes.render);
		});
	}
}
