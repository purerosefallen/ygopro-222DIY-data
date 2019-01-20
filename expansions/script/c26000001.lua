--帝国之创始者 双子王
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=26000001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	rsef.I(c,nil,nil,EFFECT_FLAG_CARD_TARGET,LOCATION_PZONE,1,cm.con,rscost.reglabel(100),cm.tg,cm.op)
	rssf.SSCondition(c,true,aux.penlimit)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--match kill
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_MATCH_KILL)
	e3:SetCondition(cm.mkcon)
	c:RegisterEffect(e3)
end
function cm.con(e)
	return Duel.IsAbleToEnterBP()
end
function cm.cfilter0(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function cm.cfilter1(c,tp)
	return cm.cfilter0(c) and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,c,tp,c)
end
function cm.cfilter2(c,tp,rc)
	local g=Group.FromCards(c,rc)
	return cm.cfilter0(c) and Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_MZONE,0,1,g,tp,g)
end
function cm.cfilter3(c,tp,g)
	local sg=g:Clone()
	sg:AddCard(c)
	return cm.cfilter0(c) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,sg)
end
function cm.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsType(TYPE_PENDULUM) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then
		if e:GetLabel()~=100 then
			return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_MZONE,0,1,1,tc1,tp,tc1):GetFirst()
		local rg=Group.FromCards(tc1,tc2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc3=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,LOCATION_MZONE,0,1,1,rg,tp,rg):GetFirst()
		rg:AddCard(tc3)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)   
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(aux.FilterBoolFunction(Card.IsFaceup))
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATCH_KILL)
	e1:SetCondition(cm.con2)
	e1:SetReset(rsreset_est_pend)
	tc:RegisterEffect(e1)	
end 
function cm.con2(e)
	local c=e:GetHandler()
	return c:GetBattleTarget()==nil
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_BEAST)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_BEAST)
	local g=Duel.SelectTribute(tp,c,3,3,mg)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.tlimit(e,c)
	return not c:IsRace(RACE_DRAGON)
end
function cm.mkcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetBattleTarget()==nil and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
