--流雾麟 雷暴之柷
local m=21400045
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--cannot special summon
--	local e00=Effect.CreateEffect(c)
--	e00:SetType(EFFECT_TYPE_SINGLE)
--	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--	e00:SetCode(EFFECT_SPSUMMON_CONDITION)
--	e00:SetValue(aux.ritlimit)
--	c:RegisterEffect(e00)   

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCost(cm.rlcost)
	e0:SetTarget(cm.rltarget)
	e0:SetOperation(cm.rloperation)
	c:RegisterEffect(e0)


	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.syncon)
	e1:SetCode(EFFECT_HAND_SYNCHRO)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)


	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.sccon)
	e2:SetTarget(cm.sctarg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)



	--break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(cm.jftg)
	e3:SetOperation(cm.jfop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(cm.dtcon)
	c:RegisterEffect(e4)


	--set p
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
--	e5:SetCondition(cm.tgcon)
	e5:SetTarget(cm.tgtg)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)

end

function cm.dwfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.dwfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,e:GetHandler()) end
	--if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end


function cm.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function cm.dtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp
end

function cm.mat_filter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end

function cm.jffl(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function cm.jflmt(e,ep,tp)
	return tp==ep 
end
function cm.jftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(cm.jflmt)
end
function cm.jfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local pp=tc:GetControler()
	if tc:IsRelateToEffect(e) then
		local cntrn=Duel.Destroy(tc,nil,REASON_EFFECT)
		--if cntrn<=0 then return end
		--if( Duel.IsExistingTarget(cm.jffl,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) and ( Duel.CheckLocation(pp,LOCATION_PZONE,0) or Duel.CheckLocation(pp,LOCATION_PZONE,1) ) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) ) then
			--local sg=Duel.SelectMatchingCard(tp,cm.jffl,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
			--local sc=sg:GetFirst()
			--if sc then Duel.MoveToField(sc,tp,pp,LOCATION_SZONE,POS_FACEUP,true) end
		--end
	end
end


function cm.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function cm.rltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function cm.rloperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function cm.mtfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function cm.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsExistingTarget(cm.mtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
		--and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,mg) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

--function cm.ssfl(c)

function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.mtilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local cntrn=Duel.SendtoHand(g,nil,REASON_EFFECT)
		if cntrn<=0 then return end
		local c=e:GetHandler()
		if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
		--if not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then return end
		--local e3=Effect.CreateEffect(e:GetHandler())
		--e3:SetType(EFFECT_TYPE_SINGLE)
		--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		--e3:SetCode(EFFECT_HAND_SYNCHRO)
		--e3:SetTargetRange(0,1)
		--e:GetHandler():RegisterEffect(e3,true)
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
		--Effect.Reset(e3)
	end
end
