--玲珑阵图-共振
function c21520072.initial_effect(c)
	--active
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c21520072.actcon)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520072,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520072.thtg)
	e1:SetOperation(c21520072.thop)
	c:RegisterEffect(e1)
	--cannot disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c21520072.effectfilter)
	c:RegisterEffect(e2)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_CANNOT_DISABLE)
	e2_1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e2_1:SetRange(LOCATION_SZONE)
	e2_1:SetTarget(c21520072.effectfilter2)
	c:RegisterEffect(e2_1)
end
function c21520072.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21520072.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:IsFaceup()
end
function c21520072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520072.thfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
end
function c21520072.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520072.thfilter,tp,LOCATION_ONFIELD,0,c)
	local opg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and opg:GetCount()>0 and c:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local osg=opg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.SendtoHand(osg,nil,REASON_EFFECT)
--		Duel.ConfirmCards(1-tp,sg)
--		Duel.ConfirmCards(tp,osg)
	end
end
function c21520072.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x495)
end
function c21520072.effectfilter2(e,c)
	return c:IsSetCard(0x495) and c:IsType(TYPE_MONSTER)
end
