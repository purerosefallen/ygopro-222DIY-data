--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030011
local cm=_G["c"..m]
cm.rssetcode="yatori"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	local e1=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"rec","de",nil,nil,cm.rectg,cm.recop)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,1},1,"neg","dcal,dsp",LOCATION_MZONE,rscon.negcon(cm.cfilter),rscost.cost({aux.FilterBoolFunction(rscf.CheckSetCard,"yatori"),"res",LOCATION_MZONE,0,1,1,c}),cm.negtg,cm.negop)
	local e3=rsef.STO(c,EVENT_TO_GRAVE,{m,2},{1,m},"sp","tg,de",cm.spcon,nil,rstg.target({cm.spfilter,"sp",LOCATION_GRAVE }),cm.spop)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("yatori") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc)
	end
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function cm.cfilter(e,tp,re,rp)
	return re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(20000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,20000)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.damcon)
	e1:SetOperation(cm.damop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(1000)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.damcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function cm.damop(e,tp)
	Duel.Damage(tp,20000,REASON_EFFECT)
end
