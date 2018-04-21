--猫耳天堂-牛奶
function c4210007.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210007,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,4210007)
	e1:SetTarget(c4210007.tgtg)
	e1:SetOperation(c4210007.tgop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210007,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c4210007.cost)
	e2:SetTarget(c4210007.target)
	e2:SetOperation(c4210007.operation)
	c:RegisterEffect(e2)
	--add race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(0xff)
	e3:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e3)
end
function c4210007.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c4210007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210001.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)		
	local g=Duel.SelectTarget(tp,c4210007.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ONFIELD)
	if(g:GetFirst():GetFlagEffect(4210010)~=0)then 
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end	
end
function c4210007.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local sg=Group.CreateGroup()	
	if(c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e)and c:IsAbleToHand() and tc:IsRelateToEffect(e) and tc:IsAbleToHand())then 
		sg:AddCard(c)
		sg:AddCard(tc)
		if sg:GetCount()>0 then
			if(tc:GetFlagEffect(4210010)~=0)then 
				Duel.Damage(1-tp,500,REASON_EFFECT)
			end
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function c4210007.filter(c)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c4210007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210007.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210007.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4210007.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
