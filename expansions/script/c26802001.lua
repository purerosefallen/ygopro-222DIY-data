--白色情人节·柏木翼
function c26802001.initial_effect(c)
	c:SetUniqueOnField(1,0,26802001)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c26802001.sumlimit)
	e1:SetCondition(c26802001.dscon)
	c:RegisterEffect(e1)
	--remove material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c26802001.rmcon)
	e4:SetOperation(c26802001.rmop)
	c:RegisterEffect(e4)
end
function c26802001.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c26802001.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetBaseAttack()>2800
end
function c26802001.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26802001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
