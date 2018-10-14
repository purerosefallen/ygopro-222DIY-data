--碾压墙
local m=69696601
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,lc)
	return c:GetSequence()==lc
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,2,nil) end
	local i,j=0,4
	local dg=Group.CreateGroup()
	while i<3 or j>1 do
		if i~=3 then
			local g1=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,i)
			if g1:GetCount()>0 then 
				dg:Merge(g1)
				i=3
			else i=i+1 end
		end
		if j~=1 then
			local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,j)
			if g2:GetCount()>0 then 
				dg:Merge(g2)
				j=1 
			else j=j-1 end
		end
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,2,0,0)
	if Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,3,nil,POS_FACEUP) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
	dg:Clear()
end
function cm.chainlm(e,rp,tp)
	return tp==rp and not e:IsActiveType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local i,j=0,4
	local dg=Group.CreateGroup()
	while i<3 or j>1 do
		if i~=3 then
			local g1=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,i)
			if g1:GetCount()>0 then 
				dg:Merge(g1)
				i=3
			else i=i+1 end
		end
		if j~=1 then
			local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,j)
			if g2:GetCount()>0 then 
				dg:Merge(g2)
				j=1 
			else j=j-1 end
		end
	end
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_RULE)
	end
	dg:Clear()
end