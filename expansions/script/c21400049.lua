--流雾麟 沙尘之埙
local m=21400049
local cm=_G["c"..m]
function c21400049.initial_effect(c)
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
	e0:SetDescription(aux.Stringid(21400049,0))
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCost(c21400049.rlcost)
	e0:SetTarget(c21400049.rltarget)
	e0:SetOperation(c21400049.rloperation)
	c:RegisterEffect(e0)

	--mu di hui shou
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400049,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400049)
	e1:SetCost(c21400049.thcost)
	e1:SetOperation(c21400049.op)
	c:RegisterEffect(e1)


	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400049,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c21400049.dtg)
	e2:SetOperation(c21400049.dop)
	c:RegisterEffect(e2)

end

function c21400049.mat_filter(c)
	return not c:IsLocation(LOCATION_GRAVE)
end

function c21400049.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c21400049.rltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c21400049.rloperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c21400049.jffilter(c)
	return c:IsReleasable() and ( c:GetSequence()==0 or c:GetSequence()==4 )
end

function c21400049.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  
		if not Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e) then return false end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
			then return Duel.IsExistingMatchingCard(c21400049.jffilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsFacedown,1-tp,0,LOCATION_EXTRA,1,nil) 
		else return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsFacedown,1-tp,0,LOCATION_EXTRA,1,nil) end
	end

	local g
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) 
		then g=Duel.SelectMatchingCard(tp,c21400049.jffilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	else 
		g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	end
	
	Duel.Release(g,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c21400049.splimit(e,c,sump,sumtype,sumpos,targetp,atb)
	return c:IsLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) and c:IsAttribute(atb)
end

function cm.tdfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end

function c21400049.op(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	--local atb=Duel.AnnounceAttribute(tp,1,0xffff)
	--local gg=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,atb)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	--local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
	
	--Duel.SendtoDeck(gg,nil,233,REASON_EFFECT)



	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e)
	local tc=g:GetFirst()
	local att=0
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local ac=Duel.AnnounceAttribute(tp,1,att)
	gg=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,ac)
	Duel.SendtoDeck(gg,nil,233,REASON_EFFECT)

	--splimit
--  local e1=Effect.CreateEffect(e:GetHandler())
--  e1:SetType(EFFECT_TYPE_FIELD)
--  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
--  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
--  e1:SetTargetRange(1,1)
--  e1:SetTarget(c21400049.splimit,atb)
 --   Duel.RegisterEffect(e1,tp)
end

function c21400049.dfilter(c)
	return c:IsSetCard(0xc20) and c:IsAbleToHand()
end
function cm.dwfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToRemove()
end
function c21400049.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400049.dfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c21400049.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c21400049.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400049.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c21400049.dwfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end






