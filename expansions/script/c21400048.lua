--流雾麟 冰雹之鼓

local m=21400048
local cm=_G["c"..m]
function c21400048.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	c:EnableReviveLimit()
	--cannot special summon
	--local e00=Effect.CreateEffect(c)
	--e00:SetType(EFFECT_TYPE_SINGLE)
	--e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e00:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e00:SetValue(aux.ritlimit)
	--c:RegisterEffect(e00)   
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21400048,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c21400048.rlcost)
	e0:SetTarget(c21400048.rltarget)
	e0:SetOperation(c21400048.rloperation)
	c:RegisterEffect(e0)

	--chu wai
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400048,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400048)
	e1:SetCost(c21400048.thcost)
	e1:SetTarget(c21400048.thtg)
	e1:SetOperation(c21400048.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400048,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c21400048.dtg)
	e2:SetOperation(c21400048.dop)
	c:RegisterEffect(e2)

end

function c21400048.mat_filter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end

function c21400048.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c21400048.rltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c21400048.rloperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c21400048.jffilter(c)
	return c:IsReleasable() and ( c:GetSequence()==0 or c:GetSequence()==4 )
end

function c21400048.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
			then return Duel.IsExistingMatchingCard(c21400048.jffilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) 
		else return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	end

	local g
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
		then g=Duel.SelectMatchingCard(tp,c21400048.jffilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	else 
		g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	end
	
	Duel.Release(g,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c21400048.gtfl2(c,ty)
	--return c:IsAbleToRemove() and c:IsFaceup()
	return not c:IsType(ty) and c:IsAbleToRemove() and c:IsFaceup()
end

function c21400048.gtfl(c)
	return c:IsAbleToRemove() and c:IsFaceup()
	--local ty=TYPE_MONSTER
	--if c:IsType(TYPE_MONSTER) then ty=TYPE_MONSTER end
	--if c:IsType(TYPE_SPELL) then ty=TYPE_SPELL end
	--if c:IsType(TYPE_TRAP) then ty=TYPE_TRAP end
	--return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c21400048.gtfl2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ty) and c:IsFaceup()
end

function c21400048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Duel.IsExistingMatchingCard(c21400048.gtfl,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,LOCATION_ONFIELD,LOCATION_ONFIELD)
end

function c21400048.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21400048.gtfl,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	--local ty
	--if tc:IsType(TYPE_MONSTER) then ty=TYPE_MONSTER end
	--if tc:IsType(TYPE_SPELL) then ty=TYPE_SPELL end
	--if tc:IsType(TYPE_TRAP) then ty=TYPE_TRAP end
	if tc and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(21400048,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c21400048.retcon)
		e1:SetOperation(c21400048.retop)
		Duel.RegisterEffect(e1,tp)
	end

	--g=Duel.SelectMatchingCard(tp,c21400048.gtfl2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ty)
	--tc=g:GetFirst()
	--if tc and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
	--	tc:RegisterFlagEffect(21400048,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	--	local e1=Effect.CreateEffect(e:GetHandler())
	 --   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--	e1:SetCode(EVENT_PHASE+PHASE_END)
	--	e1:SetReset(RESET_PHASE+PHASE_END)
	--	e1:SetLabelObject(tc)
	--	e1:SetCountLimit(1)
	--	e1:SetCondition(c21400048.retcon)
	--	e1:SetOperation(c21400048.retop)
	 --   Duel.RegisterEffect(e1,tp)
	--end  
end

function c21400048.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(21400048)~=0
end
function c21400048.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

function c21400048.dfilter(c)
	return c:IsSetCard(0xc20) and c:IsAbleToHand()
end
function cm.dwfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemove()
end
function c21400048.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400048.dfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c21400048.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c21400048.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400048.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c21400048.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end






