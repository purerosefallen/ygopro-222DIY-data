
--小黑
function c12031000.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c12031000.atkcon)
	e1:SetValue(c12031000.atkval)
	c:RegisterEffect(e1)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12031000,0))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c12031000.econ)
	e4:SetValue(c12031000.efilter)
	c:RegisterEffect(e4) 
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12031000,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c12031000.tdtg)
	e3:SetOperation(c12031000.tdop)
	c:RegisterEffect(e3)
end
function c12031000.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfa0)
end
function c12031000.atkcon(e)
	return Duel.IsExistingMatchingCard(c12031000.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c12031000.atkval(e,c)
	local tt=Duel.GetMatchingGroupCount(c12031000.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,e:GetHandler())
	return 1000*tt
end
function c12031000.econ(e)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c12031000.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12031000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c12031000.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
