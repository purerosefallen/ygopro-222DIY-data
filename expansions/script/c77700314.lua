--BB，永久与炫目的月癌
local m=77700314
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and c:IsReleasable()
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
		and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.filter2(c,lv,e,tp)
	return c:IsCode(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		cm.ReplaceEffectExtraCount(tc,3,code,0x1fe1000+RESET_PHASE+PHASE_END,1)
		Duel.SpecialSummonComplete()
	end
end
function cm.ReplaceEffectExtraCount(c,ctlm,code,res,resct)
	if not ctlm then return c:CopyEffect(code,res,resct) end
	local et={}
	local ef=Effect.SetCountLimit
	local rf=Card.RegisterEffect
	Effect.SetCountLimit=cm.replace_set_count_limit(et)
	Card.RegisterEffect=cm.replace_register_effect(et,ctlm,ef,rf)
	c:RegisterFlagEffect(37564768,res,0,resct,ctlm)
	local cid=c:ReplaceEffect(code,res,resct)
	Effect.SetCountLimit=ef
	Card.RegisterEffect=rf
	c:ResetFlagEffect(37564768)
	return cid
end
function cm.replace_set_count_limit(et)
return function(e,ct,cd)
	et[e]={ct,cd}
end
end
function cm.replace_register_effect(et,ctlm,ef,rf)
return function(c,e,forced)
	local t=et[e]   
	if t then
		if e:IsHasType(0x7e0) then
			t[1]=math.max(t[1],ctlm)
		end
		ef(e,table.unpack(t))
	end
	rf(c,e,forced)
end
end