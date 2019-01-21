--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030006
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030006.initial_effect(c)
	c:EnableReviveLimit()
	 --summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030006,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c12030006.ttcon1)
	e1:SetOperation(c12030006.ttop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030006,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP_ATTACK,1)
	e2:SetCondition(c12030006.ttcon2)
	e2:SetOperation(c12030006.ttop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(c12030006.setcon)
	c:RegisterEffect(e3)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030006,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12030006)
	e3:SetCondition(c12030006.condition1)
	e3:SetTarget(c12030006.target)
	e3:SetOperation(c12030006.operation1)
	c:RegisterEffect(e3)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030006,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12031006)
	e3:SetCondition(c12030006.condition2)
	e3:SetTarget(c12030006.target)
	e3:SetOperation(c12030006.operation)
	c:RegisterEffect(e3)
	--return
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(12030006,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetTarget(c12030006.rettg)
	e7:SetOperation(c12030006.retop)
	c:RegisterEffect(e7)
end
function c12030006.ttcon1(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c12030006.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12030006.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp)
end
function c12030006.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c12030006.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c12030006.condition1(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==1-tp
end
function c12030006.condition2(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==tp
end
function c12030006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12030006.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c12030006.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c12030006.ccfilter(c)
	return c:IsAbleToHandAsCost() and c:IsType(TYPE_MONSTER) 
end
function c12030006.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local th=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local rh=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ( th~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,0,LOCATION_GRAVE,5-th,nil) ) or
						  ( rh~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,LOCATION_GRAVE,0,5-rh,nil) ) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),5-th,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),5-rh,0,0)
end
function c12030006.retop(e,tp,eg,ep,ev,re,r,rp)
	local th=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local rh=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if not ( ( th~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,0,LOCATION_GRAVE,5-th,nil) ) or 
			 ( rh~=5 and Duel.IsExistingMatchingCard(c12030006.ccfilter,tp,LOCATION_GRAVE,0,5-rh,nil) ) ) then return end
	if th<5 then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local rg=Duel.SelectMatchingCard(1-tp,c12030006.ccfilter,1-tp,0,LOCATION_GRAVE,5-th,5-th,nil)
		  if rg:GetCount()>0 then 
	local upa=0
	local tc=rg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=rg:GetNext()
		  e:SetLabel(upa)
	end
	Duel.SendtoHand(rg,1-tp,REASON_EFFECT)
	else
	rg=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,0,LOCATION_HAND,5-th,5-th,nil,TYPE_MONSTER)
		if rg:GetCount()>0 then 
	local upa=0
	local tc=rg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=rg:GetNext()
		  e:SetLabel(upa)
	end
	end
	Duel.SendtoGrave(rg,REASON_EFFECT)
	local dem1=e:GetLabel()
	Duel.Damage(1-tp,dem1,REASON_EFFECT)
	if rh<5 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c12030006.ccfilter,tp,LOCATION_GRAVE,0,5-rh,5-rh,nil)
	if tg:GetCount()>0 then 
	local upa=0
	local tc=tg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=tg:GetNext()
		  e:SetLabel(upa)
	end
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	else
	tg=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,0,LOCATION_HAND,5-th,5-th,nil,TYPE_MONSTER)
		if tg:GetCount()>0 then 
	local upa=0
	local tc=tg:GetFirst()
	while tc do
		  local upa1=tc:GetAttack()
		  upa=upa+upa1
		  tc=tg:GetNext()
		  e:SetLabel(upa)
	end
	end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local dem2=e:GetLabel()
	Duel.Damage(tp,dem2,REASON_EFFECT)
end