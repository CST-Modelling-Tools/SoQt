/**************************************************************************\
 *
 *  This file is part of the Coin 3D visualization library.
 *  Copyright (C) 1998-2003 by Systems in Motion.  All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  ("GPL") version 2 as published by the Free Software Foundation.
 *  See the file LICENSE.GPL at the root directory of this source
 *  distribution for additional information about the GNU GPL.
 *
 *  For using Coin with software that can not be combined with the GNU
 *  GPL, and for taking advantage of the additional benefits of our
 *  support services, please contact Systems in Motion about acquiring
 *  a Coin Professional Edition License.
 *
 *  See <URL:http://www.coin3d.org> for more information.
 *
 *  Systems in Motion, Teknobyen, Abels Gate 5, 7030 Trondheim, NORWAY.
 *  <URL:http://www.sim.no>.
 *
\**************************************************************************/

#include <qpushbutton.h>
#include <qgroupbox.h>
#include <qlayout.h>
#include <qcolordialog.h>
#include <qlabel.h>
#include <qcanvas.h>
  
#include "GradientEditor.h"
#include "GradientView.h"
#include <Inventor/Qt/widgets/Gradient.h>

#include <Inventor/Qt/widgets/moc_GradientEditor.icc>


GradientEditor::GradientEditor(const Gradient & grad, 
                               QWidget * parent, 
                               bool modal, 
                               const char* name, 
                               WFlags f)
: QWidget(parent, name, f)
{
  this->min = 0;
  this->max = 255;

  QVBoxLayout * topLayout = new QVBoxLayout(this);
  QHBoxLayout * buttonOutputLayout = new QHBoxLayout();
  QVBoxLayout * outputLayout = new QVBoxLayout();
  QHBoxLayout * buttonLayout = new QHBoxLayout();

  buttonOutputLayout->addLayout(outputLayout);
  buttonOutputLayout->addLayout(buttonLayout);

  this->gradientWidget = new QWidget(this, "gradientWidget");
  this->gradientWidget->setMinimumHeight(80);
  topLayout->addWidget(this->gradientWidget);
  topLayout->addLayout(buttonOutputLayout);
  
  QCanvas * canvas = new QCanvas(500,60);
  this->gradView = new GradientView(canvas, grad, gradientWidget, "GradientView");
  this->gradView->setFrameStyle(QFrame::Sunken);

  QGroupBox * dataValues = new QGroupBox(this, "dataValues");
  dataValues->setColumns(3);
  dataValues->setOrientation(Qt::Vertical);
  outputLayout->addWidget(dataValues);

  this->dataValue = new QLabel(dataValues, "dataValue");
  this->dataValue->setMinimumWidth(200);
  this->colorLabel = new QLabel(dataValues, "colorLabel");
  this->dataValue->setMinimumWidth(200);

  buttonLayout->setAlignment(Qt::AlignRight | Qt::AlignBottom);

  QPushButton * okButton = new QPushButton(this, "okButton");
  okButton->setText("OK");
  buttonLayout->addWidget(okButton, 0, 1);

  QPushButton * cancelButton = new QPushButton(this, "cancelButton");
  cancelButton->setText("Cancel");
  buttonLayout->addWidget(cancelButton, 0, 1);

  // FIXME: not a good way to hook into the GradientView tick mark
  // values this, should replace with something better. Tooltips on
  // the tick marks, perhaps? 20031008 mortene.
  connect(this->gradView, SIGNAL(viewChanged()), this, SLOT(updateValueLabels()));
  connect(this->gradView, SIGNAL(tickSelected()), this, SLOT(updateValueLabels()));

  connect(cancelButton, SIGNAL(clicked()), this, SLOT(reject()));
  connect(okButton, SIGNAL(clicked()), this, SLOT(accept()));

  this->updateValueLabels();
}

GradientEditor::~GradientEditor()
{
  delete this->gradView;
}

void GradientEditor::resizeEvent(QResizeEvent * e)
{
  this->gradientWidget->resize(QSize(e->size().width(), 60));
  this->gradView->resize(QSize(e->size().width(), 60));
  this->repaint();
}
void GradientEditor::setMin(int min)
{
  this->min = min;
}

void GradientEditor::setMax(int max)
{
  this->max = max;
}

void GradientEditor::updateValueLabels()
{
  float t = this->gradView->getSelectedPos();
  int value = int(t * (this->max - this->min) + this->min);

  Gradient grad = this->gradView->getGradient();
  QRgb col = grad.eval(t);

  this->dataValue->setText(QString(" Colortable index: ") + QString().setNum(value));

  QString s;
  s.sprintf("0x%02x%02x%02x%02x", qRed(col), qGreen(col), qBlue(col), qAlpha(col));
  this->colorLabel->setText(QString(" RBGA: ") + s);
}

const Gradient& GradientEditor::getGradient() const
{
  return this->gradView->getGradient();
}

void GradientEditor::setGradient(const Gradient & grad)
{
  this->gradView->setGradient(grad);
}

void GradientEditor::updateAll()
{  
  this->gradView->updateTicks();
  this->gradView->updateView();
}

// FIXME: callback is not really used from this class, just passed on
// to the Gradient class. Should look into design to see if we can
// remove this method. 20031008 mortene.
void
GradientEditor::setChangeCallback(Gradient::ChangeCB * cb, void * userdata)
{
  this->gradView->setChangeCallback(cb, userdata);
}

void GradientEditor::accept()
{
  emit this->accepted();
}

void GradientEditor::reject()
{
  emit this->rejected();
}