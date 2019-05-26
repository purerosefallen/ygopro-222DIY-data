--航空管家·北上丽花
require("expansions/script/c81000000")
function c81015044.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81015044,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,81015044)
	e1:SetCondition(c81015044.descon)
	e1:SetTarget(c81015044.destg)
	e1:SetOperation(c81015044.desop)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81015044.lvcon)
	e2:SetValue(3)
	c:RegisterEffect(e2) 
end
function c81015044.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a) and not c:IsType(TYPE_TUNER)
end
function c81015044.lvcon(e)
	return Duel.IsExistingMatchingCard(c81015044.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c81015044.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and Tenka.ReikaCon(e,tp,eg,ep,ev,re,r,rp)
end
function c81015044.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81015044.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c81015044.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015044.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81015044.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81015044.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
