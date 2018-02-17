--虚太古龙·虚梦龙
function c10162008.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9333),3,3)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10162008,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10162008.negcost)
	e1:SetTarget(c10162008.negtg)
	e1:SetOperation(c10162008.negop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10162008.desreptg)
	e2:SetValue(c10162008.desrepval)
	e2:SetOperation(c10162008.desrepop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c10162008.antarget)
	c:RegisterEffect(e4) 
end
function c10162008.antarget(e,c)
	return c~=e:GetHandler()
end
function c10162008.repfilter(c,g)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and g:IsContains(c)
end
function c10162008.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	if chk==0 then return eg:IsExists(c10162008.repfilter,1,nil,g) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function c10162008.desrepval(e,c)
	return c10162008.repfilter(c,e:GetHandler():GetLinkedGroup())
end
function c10162008.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,10162008)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10162008.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10162008.negfilter(c,e)
	return aux.disfilter1(c) and c:IsCanBeEffectTarget(e)
end
function c10162008.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(c10162008.negfilter,tp,LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(c10162008.negfilter,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return false end
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	local ct=math.min(g1:GetCount(),g2:GetCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tg1=g1:Select(tp,ct,ct,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local tg2=g2:Select(tp,ct,ct,nil)
	tg1:Merge(tg2)
	Duel.SetTargetCard(tg1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg1,tg1:GetCount(),0,LOCATION_ONFIELD)
end
function c10162008.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	for tc in aux.Next(tg) do
		if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
			   local e3=e1:Clone()
			   e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			   tc:RegisterEffect(e3)
			end
	   end
	end
end

