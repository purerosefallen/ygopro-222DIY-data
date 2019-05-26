--听春零 春华急似晓天星

local m=21410131
local cm=_G["c"..m]
local mmid=21410130

function c21410131.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(mmid)
	c:RegisterEffect(e1)

	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	--e2:SetCountLimit(1,m+80000)
	e2:SetTarget(cm.pstg)
	e2:SetOperation(cm.psop)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.reccon)
	e4:SetTarget(cm.rectg)
	e4:SetOperation(cm.recop)
	c:RegisterEffect(e4)
	--local e5=e4:Clone()
	--e5:SetCode(mmid)
	--e5:SetCondition(aux.TRUE)
	--c:RegisterEffect(e5)
	--recover
	--local e5=Effect.CreateEffect(c)
	--e5:SetDescription(aux.Stringid(m,1))
	--e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e5:SetCode(mmid)
	--e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e5:SetCountLimit(1,m)
	--e5:SetTarget(cm.rectgdebug)
	--e5:SetOperation(cm.recop)
	--c:RegisterEffect(e5)

end

function cm.psfilter(c)
	return c:IsSetCard(0x6c25) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.psfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local seq=e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	Debug.Message("gotin")
	Debug.Message(r)
	Debug.Message(REASON_FUSION)
	Debug.Message(REASON_LINK)
	Debug.Message(REASON_RELEASE)
	return rc:IsSetCard(0x6c25) and (rc:IsType(TYPE_FUSION) or rc:IsType(TYPE_LINK)) and r & REASON_FUSION+REASON_LINK+REASON_SPSUMMON ~=0 
end
function cm.filter(c,e,tp)
	return c:IsCode(mmid) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_PZONE)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end


