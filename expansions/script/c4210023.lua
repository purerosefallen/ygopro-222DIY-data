--枫浆苹果肉桂松饼
function c4210023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCountLimit(1,4210023)
	e1:SetCost(c4210023.cost1)
	e1:SetCondition(c4210023.condition)
	e1:SetTarget(c4210023.target)
	e1:SetOperation(c4210023.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210023,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4210023)
	e2:SetCost(c4210023.cost)
	e2:SetTarget(c4210023.tg)
	e2:SetOperation(c4210023.op)
	c:RegisterEffect(e2)
end
function c4210023.filter(c)
	return (c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_MONSTER)
end
function c4210023.condition(e,c)
	return (not Duel.IsExistingMatchingCard(c4210023.filter,tp,LOCATION_MZONE,0,1,nil))
		or Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)==0 
end
function c4210023.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	if g:GetFirst():GetFlagEffect(4210010)~=0 then e:SetLabel(1) end
	Duel.Release(g,REASON_COST)
end
function c4210023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
	if e:GetLabel() == 1 then 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c4210023.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
		if e:GetLabel() == 1 then 
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c4210023.rmfilter(c)
	return (c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_MONSTER)
end
function c4210023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210023.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210023.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c4210023.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end