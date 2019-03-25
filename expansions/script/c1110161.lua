--并蒂的灵魂遐想
local m=1110161
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110161.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110161,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1110161.LinkCondition0(c1110161.filter1,2,2))
	e1:SetTarget(c1110161.LinkTarget0(c1110161.filter1,2,2))
	e1:SetOperation(c1110161.LinkOperation0(c1110161.filter1,2,2))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110161,1))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1110161.LinkCondition(c1110161.filter2,1,1))
	e2:SetTarget(c1110161.LinkTarget(c1110161.filter2,1,1))
	e2:SetOperation(c1110161.LinkOperation(c1110161.filter2,1,1))
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1110161,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1110161.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110161.filter1(c)
	return c:IsLevel(3)
end
function c1110161.Linkfilter(c)
	return c:IsAbleToRemoveAsCost() and muxu.check_set_Butterfly(c)
end
function c1110161.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if Duel.GetFlagEffect(tp,1111025)>0 then
		local mg3=Duel.GetMatchingGroup(c1110161.Linkfilter,tp,LOCATION_GRAVE,0,nil)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	return mg
end
function c1110161.LinkCondition0(f,minc,maxc,gf)
	return
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=c1110161.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(aux.LCheckGoal,min,max,tp,c,gf)
	end
end
function c1110161.LinkTarget0(f,min,max,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=c1110161.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.GetCurrentChain()==0
		local sg=mg:SelectSubGroup(tp,aux.LCheckGoal,cancel,min,max,tp,c,gf)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function c1110161.LinkOperation0(f,min,max,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		local sg=g:Filter(c1110161.Linkfilter,nil)
		if sg:GetCount()>0 then
			Duel.Remove(sg,POS_FACEUP,REASON_MATERIAL+REASON_COST)
			g:Sub(sg)
		end
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		end
		g:DeleteGroup()
		sg:DeleteGroup()
	end
end
--
function c1110161.filter2(c)
	return c:IsLinkType(TYPE_TOKEN) and c:IsLevel(3)
end
function c1110161.LCheckGoal(sg,tp,lc,gf)
	return sg:CheckWithSumEqual(aux.GetLinkCount,1,#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc)
end
function c1110161.LinkCondition(f,minc,maxc,gf)
	return
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=aux.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(c1110161.LCheckGoal,min,max,tp,c,gf)
	end
end
function c1110161.LinkTarget(f,minc,maxc,gf)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=aux.GetLinkMaterials(tp,f,c)
		local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.GetCurrentChain()==0
		local sg=mg:SelectSubGroup(tp,c1110161.LCheckGoal,cancel,min,max,tp,c,gf)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function c1110161.LinkOperation(f,min,max,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		g:DeleteGroup()
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_SINGLE)
		e0_1:SetCode(EFFECT_ADD_TYPE)
		e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0_1:SetValue(TYPE_SPIRIT)
		e0_1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e0_1,true)
		local e0_2=Effect.CreateEffect(c)
		e0_2:SetType(EFFECT_TYPE_SINGLE)
		e0_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e0_2:SetValue(1)
		e0_2:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e0_2,true)
	end
end
--
function c1110161.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD)
	e3_1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3_1:SetTargetRange(LOCATION_MZONE,0)
	e3_1:SetTarget(c1110161.tg3_1)
	e3_1:SetValue(1)
	e3_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3_1,tp)
end
--
function c1110161.tg3_1(e,c)
	return muxu.check_set_Urban(c)
end
--
