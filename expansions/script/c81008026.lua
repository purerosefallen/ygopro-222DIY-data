--冰雪风暴·大石泉
function c81008026.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c81008026.splimcona)
	e1:SetTarget(c81008026.splimita)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(c81008026.splimitb)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTarget(c81008026.splimitc)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetTarget(c81008026.splimitd)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c81008026.splimconb)
	e5:SetTarget(c81008026.splimita)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetTarget(c81008026.splimitb)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetTarget(c81008026.splimitc)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetTarget(c81008026.splimitd)
	c:RegisterEffect(e8)
end
function c81008026.splimcona(e)
	return Duel.GetTurnPlayer()==tp
end
function c81008026.splimconb(e)
	return Duel.GetTurnPlayer()~=tp
end
function c81008026.splimita(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c81008026.splimitb(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c81008026.splimitc(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c81008026.splimitd(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
