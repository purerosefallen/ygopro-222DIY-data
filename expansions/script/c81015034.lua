--蓝色情人节·北上丽花
require("expansions/script/c81000000")
function c81015034.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81015034)
	e1:SetCondition(Tenka.ReikaCon)
	e1:SetCost(c81015034.tdcost)
	e1:SetTarget(c81015034.tdtg)
	e1:SetOperation(c81015034.tdop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,81015034)
	e2:SetCondition(c81015034.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81015034.negtg)
	e2:SetOperation(c81015034.negop)
	c:RegisterEffect(e2)
end
function c81015034.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c81015034.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c81015034.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c81015034.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015034.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81015034.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(c81015034.limit(g:GetFirst()))
end
function c81015034.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c81015034.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c81015034.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c81015034.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c81015034.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
