<?php
/* @var $this SubproductpriceController */
/* @var $data Subproductprice */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('product_id')); ?>:</b>
	<?php echo CHtml::encode($data->product_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('code')); ?>:</b>
	<?php echo CHtml::encode($data->code); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('sku')); ?>:</b>
	<?php echo CHtml::encode($data->sku); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('supplier_id')); ?>:</b>
	<?php echo CHtml::encode($data->supplier_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('unit_cp')); ?>:</b>
	<?php echo CHtml::encode($data->unit_cp); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('sptype')); ?>:</b>
	<?php echo CHtml::encode($data->sptype); ?>
	<br />

	<?php /*
	<b><?php echo CHtml::encode($data->getAttributeLabel('unit_sp_per')); ?>:</b>
	<?php echo CHtml::encode($data->unit_sp_per); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('unit_sp')); ?>:</b>
	<?php echo CHtml::encode($data->unit_sp); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('stock')); ?>:</b>
	<?php echo CHtml::encode($data->stock); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('stockvalue')); ?>:</b>
	<?php echo CHtml::encode($data->stockvalue); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('rol')); ?>:</b>
	<?php echo CHtml::encode($data->rol); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('moq')); ?>:</b>
	<?php echo CHtml::encode($data->moq); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('dontsyncwithstock')); ?>:</b>
	<?php echo CHtml::encode($data->dontsyncwithstock); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('status')); ?>:</b>
	<?php echo CHtml::encode($data->status); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('tax')); ?>:</b>
	<?php echo CHtml::encode($data->tax); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('disc')); ?>:</b>
	<?php echo CHtml::encode($data->disc); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('created_at')); ?>:</b>
	<?php echo CHtml::encode($data->created_at); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('updated_at')); ?>:</b>
	<?php echo CHtml::encode($data->updated_at); ?>
	<br />

	*/ ?>

</div>