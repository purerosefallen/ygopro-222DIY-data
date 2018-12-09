--天谴孽畜 路德维希
function c11200097.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,false) 
	--tg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200097,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,11200097)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11200097.tgcost)
	e1:SetTarget(c11200097.tgtg)
	e1:SetOperation(c11200097.tgop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11200197)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c11200097.desreptg)
	e2:SetOperation(c11200097.desrepop)
	c:RegisterEffect(e2)
end
function c11200097.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,0x13,0,1,nil,11200096) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,0x13,0,1,1,nil,11200096)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c11200097.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetFirst()
	Duel.Equip(tp,tc,c)
end
function c11200097.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200097.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c11200097.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,5):Filter(Card.IsAbleToGrave,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if tc:IsAttribute(ATTRIBUTE_DARK) and tc:GetAttack()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			e1:SetValue(tc:GetAttack())
			c:RegisterEffect(e1)   
		end
	end
	Duel.ShuffleDeck(tp)
end
