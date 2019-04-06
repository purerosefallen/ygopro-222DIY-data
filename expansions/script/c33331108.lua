--神祭小狐 三地狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331108
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEAST),2)
	c:EnableReviveLimit()
	local e3=rsef.QO(c,EVENT_CHAINING,{m,0},1,"te",nil,LOCATION_MZONE,cm.con,nil,rstg.target(rsop.list(cm.cfilter,"te",LOCATION_DECK)),cm.op)
	local e4=rsef.SV_UPDATE(c,"atk",cm.val)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.destg)
	e2:SetValue(cm.value)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.val(e,c)
	local f=function(rc)
		return rc:IsFaceup() and rc:IsSetCard(0x2553)
	end
	return Duel.GetMatchingGroupCount(f,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)*500
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.cfilter(c)
	return not c:IsForbidden() and rslf.filter0(c)
end
function cm.op(e,tp)
	local c=rscf.GetRelationThisCard()
	if not c then return end
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.imval,nil,rsreset.est_pend)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end 
function cm.imval(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function cm.dfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x2553)
end
function cm.repfilter(c)
	return c:IsSetCard(0x2553) and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_EXTRA,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x2553)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end