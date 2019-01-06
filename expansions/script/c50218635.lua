--超天星-破军摇光
function c50218635.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c50218635.splimit)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c50218635.slcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e21=e2:Clone()
	e21:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e21)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,50218635)
	e3:SetCondition(c50218635.lvcon)
	e3:SetTarget(c50218635.lvtg)
	e3:SetOperation(c50218635.lvop)
	c:RegisterEffect(e3)
	--hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetValue(LOCATION_HAND)
	e4:SetCondition(c50218635.con)
	c:RegisterEffect(e4)
end
function c50218635.splimit(e,c)
	return not c:IsSetCard(0xcb6)
end
function c50218635.slfilter(c)
	local tc1=c:GetLeftScale()
	local tc2=c:GetRightScale()
	return tc1==8 and tc2==8 and c:IsSetCard(0xcb6)
end
function c50218635.slcon(e)
	return Duel.IsExistingMatchingCard(c50218635.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c50218635.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c50218635.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50218635,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,6,lv))
end
function c50218635.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c50218635.con(e,c)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsFaceup()
end