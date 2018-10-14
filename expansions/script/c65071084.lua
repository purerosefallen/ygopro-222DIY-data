--诱捕幻灯
function c65071084.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c65071084.target)
	e1:SetOperation(c65071084.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetOperation(c65071084.disop)
	c:RegisterEffect(e4)
end
function c65071084.filter(c,g)
	return g:IsContains(c) and c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE)
end
function c65071084.desfilter(c,g)
	return g:IsContains(c)
end
function c65071084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return eg:IsExists(c65071084.filter,1,nil,cg) end
	local g=Duel.GetMatchingGroup(c65071084.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65071084.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c65071084.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c65071084.disop(e,tp)
	local c=e:GetHandler()
	local flag1=bit.band(c:GetColumnZone(LOCATION_MZONE),0xffffff00)
	local flag2=bit.band(bit.lshift(c:GetColumnZone(LOCATION_SZONE),8),0xffff00ff)
	local flag3=bit.band(c:GetColumnZone(LOCATION_MZONE),0xff00ffff)
	local flag4=bit.band(bit.lshift(c:GetColumnZone(LOCATION_SZONE),8),0xffff)
	return flag1+flag2+flag3+flag4
end
