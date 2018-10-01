--Vessel of Sin »Æ½ðÔ¿³×
function c77707707.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77707707+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77707707.cost)
	e1:SetTarget(c77707707.target)
	e1:SetOperation(c77707707.operation)
	c:RegisterEffect(e1)
end
function c77707707.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77707707.filter(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end

function c77707707.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707707.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g={}
	for p=0,1 do
		local mg=Duel.GetMatchingGroup(c77707707.filter,p,LOCATION_MZONE,0,nil)
		if #mg>0 then
			g[p]=mg:GetMaxGroup(Card.GetAttack)
		else
			g[p]=Group.CreateGroup()
		end
	end
	local g_=g[0]:Clone()
	g_:Merge(g[1])
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1 then
		local rg=Duel.GetDecktopGroup(tp,40)
		g_:Merge(rg)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g_,#g_,0,0)

end
function c77707707.operation(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	for p=0,1 do
		local mg=Duel.GetMatchingGroup(c77707707.filter,p,LOCATION_MZONE,0,nil)
		if #mg>0 then
			g[p]=mg:GetMaxGroup(Card.GetAttack)
		else
			g[p]=Group.CreateGroup()
		end
		if #g[p]>1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local sg=g[p]:Select(p,1,1,nil)
			rg:Merge(sg)
		else
			rg:Merge(g[p])
		end
	end
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0 then
			Duel.BreakEffect()
			local dg=Duel.GetDecktopGroup(tp,40)
			Duel.DisableShuffleCheck()
			Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end