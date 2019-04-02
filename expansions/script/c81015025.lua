--悠闲假日·北上丽花
require("expansions/script/c81000000")
function c81015025.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,4)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(81015025,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81015025+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c81015025.descon1)
	e2:SetCost(c81015025.descost)
	e2:SetTarget(c81015025.destg)
	e2:SetOperation(c81015025.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c81015025.descon2)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81015025,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81015925)
	e4:SetCondition(Tenka.ReikaCon)
	e4:SetTarget(c81015025.mttg)
	e4:SetOperation(c81015025.mtop)
	c:RegisterEffect(e4)
end
function c81015025.cfilter(c)
	return c:GetSequence()<5
end
function c81015025.descon1(e,tp,eg,ep,ev,re,r,rp)
	return not Tenka.ReikaCon(e)
end
function c81015025.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Tenka.ReikaCon(e)
end
function c81015025.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81015025.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81015025.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c81015025.mtfilter(c,e)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x81a)
end
function c81015025.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c81015025.mtfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
end
function c81015025.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c81015025.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
