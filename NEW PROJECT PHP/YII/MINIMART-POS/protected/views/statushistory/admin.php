<?php
$this->breadcrumbs=array(
	'Statushistories'=>array('index'),
	'Manage',
);

$this->menu=array(
array('label'=>'List Statushistory','url'=>array('index')),
array('label'=>'Create Statushistory','url'=>array('create')),
);

Yii::app()->clientScript->registerScript('search', "
$('.search-button').click(function(){
$('.search-form').toggle();
return false;
});
$('.search-form form').submit(function(){
$.fn.yiiGridView.update('statushistory-grid', {
data: $(this).serialize()
});
return false;
});
");
?>

<h1>Manage Statushistories</h1>

<p>
	You may optionally enter a comparison operator (<b>&lt;</b>, <b>&lt;=</b>, <b>&gt;</b>, <b>&gt;=</b>, <b>
		&lt;&gt;</b>
	or <b>=</b>) at the beginning of each of your search values to specify how the comparison should be done.
</p>

<?php echo CHtml::link('Advanced Search','#',array('class'=>'search-button btn')); ?>
<div class="search-form" style="display:none">
	<?php $this->renderPartial('_search',array(
	'model'=>$model,
)); ?>
</div><!-- search-form -->

<?php $this->widget('booster.widgets.TbGridView',array(
'id'=>'statushistory-grid',
'dataProvider'=>$model->search(),
'filter'=>$model,
'columns'=>array(
		'id',
		'ofwhich_id',
		'status1dt',
		'status2dt',
		'status3dt',
		'status4dt',
		/*
		'status5dt',
		'status6dt',
		'status7dt',
		'status8dt',
		'status9dt',
		'status10dt',
		'created_at',
		'updated_at',
		*/
array(
'class'=>'booster.widgets.TbButtonColumn',
),
),
)); ?>
