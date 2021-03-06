<?php
$this->breadcrumbs=array(
    	'Product'=>array('index'),
	'Manage',
);

$this->menu=array(
    array('label'=>'List Product','url'=>array('index')),
    array('label'=>'Create Product','url'=>array('create')),
);

Yii::app()->clientScript->registerScript('search', "
$('.search-button').click(function(){
$('.search-form').toggle();
return false;
});
$('.search-form form').submit(function(){
$.fn.yiiGridView.update('product-grid', {
data: $(this).serialize()
});
return false;
});
");
?>
<div class="search-form" >
	<?php $this->renderPartial('_search',array(
	'model'=>$model,'productprice'=>$productprice
)); ?>
</div>
<?php 
$flds = $this->appFormFields['lf']['product'];
unset($flds['taxrate_id']);
unset($flds['discper']);
$flds['category_id'] = array(
                        'name' => 'category_id',
                        'value' => '($data->category_id>0?$data->categories[0]->name:"")',
                        );
//$flds['taxrate_id'] = array(
//                        'name' => 'taxrate_id',
//                        'value' => '$data->taxrate->taxrate',
//                        );
$flds['unit_cp'] = array(
                        'name' => 'unit_cp',
                        'value' => '$data->productprices[0]->unit_cp',
                        );
$flds['unit_sp'] = array(
                        'name' => 'unit_sp',
                        'value' => '$data->productprices[0]->unit_sp',
                        );
$flds['status'] = array (
                    'name'=>'status',
                    'value'=>'$data->status',
                    'class' => 'booster.widgets.TbToggleColumn',
                    //'toggleAction' => $statustoggleUrl,
                );
$viewPricesUrl = '$this->grid->controller->createUrl("productprice/'.Helper::CONST_viewProductPrices.'/$data->id")';
$btncols = array( array(
                        'class'=>'booster.widgets.TbButtonColumn',
                        'template'=>'{update}',
                        'buttons'=>array(
                            'update'=>array(
                                'url'=>'$this->grid->controller->createUrl("purchaseentry/update/$data->id")',
                            ),
//                            'prices'=>array(
//                                'url'=>$viewPricesUrl,
//                            ),
                        ),
                    ),
                );
				
$columns = array_merge($btncols, $flds);
$options = array(
            'id'=>'product-grid',
            'dataProvider'=>$model->search(),
            //'filter'=>$model,
            'columns'=> $columns,
            );
$this->setDefaultGVOptions($options);

//$this->widget('booster.widgets.TbButton', array(
//                'buttonType'=>'button',
//                'context'=>'primary',
//                'label'=> 'Add New',
//                'htmlOptions' => array(
//                    'onclick' => 'js:document.location.href="create"',
//                    'class'=>'right',
//                    )
//        ));
$this->widget('booster.widgets.TbGridView', $options); 
?>